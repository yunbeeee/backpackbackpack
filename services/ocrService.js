const { createWorker } = require('tesseract.js');
const sharp = require('sharp');
const config = require('../config/ocrConfig');
require('dotenv').config();

class OcrService {
  constructor() {
    this.cache = new Map();
    this.worker = null;
  }

  // Initialize worker once and reuse
  async getWorker() {
    if (!this.worker) {
      this.worker = await createWorker({
        langPath: process.env.TESSDATA_PREFIX,
        logger: m => console.log(m)
      });
      await this.worker.loadLanguage('kor');
      await this.worker.initialize('kor');
    }
    return this.worker;
  }

  async processImage(imageFile, language) {
    try {
      // Generate cache key based on image content
      const imageHash = await this.generateImageHash(imageFile.buffer);
      const cacheKey = `${imageHash}-${language}`;

      // Check cache
      if (this.cache.has(cacheKey)) {
        console.log('Returning cached result');
        return this.cache.get(cacheKey);
      }

      console.log('Starting OCR process for language:', language);
      console.log('Image file details:', {
        mimetype: imageFile.mimetype,
        size: imageFile.buffer.length
      });
      console.log('TESSDATA_PREFIX:', process.env.TESSDATA_PREFIX);

      // Validate inputs
      if (!imageFile || !language) {
        throw new Error('Missing required parameters: image file or language');
      }

      if (!config.supportedLanguages.includes(language)) {
        throw new Error(`Unsupported language: ${language}`);
      }

      // Validate file type
      if (!config.uploadLimits.allowedTypes.includes(imageFile.mimetype)) {
        throw new Error('Invalid file type. Only JPEG and PNG are supported');
      }

      const processedImage = await this.preprocessImage(imageFile);
      const rotatedImage = await this.detectAndFixRotation(processedImage);
      console.log('Image preprocessing and rotation correction completed');

      const worker = await this.getWorker();

      try {
        console.log('Loading language data:', language);
        await worker.loadLanguage(language);
        await worker.initialize(language);
        
        // Simplified parameters without OSD
        await worker.setParameters({
          tessedit_pageseg_mode: '6',          // Assume uniform block of text
          preserve_interword_spaces: '1',
          tessedit_char_blacklist: '!@#$%^&*()_+=[]{}|;:,.<>?~`',
          tessedit_enable_dict_correction: '1', // Enable dictionary for Korean
          textord_heavy_nr: '1',               // Enable noise removal
          tessedit_write_images: false,
          tessedit_ocr_engine_mode: '3',       // LSTM_ONLY
          load_system_dawg: '1',               // Enable system dictionary for better accuracy
          load_freq_dawg: '1',                 // Enable frequency dictionary
          tessedit_create_txt: '1',
          tessedit_create_hocr: '1',
          tessedit_char_whitelist: language === 'kor' ? 
            'ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎㅆㄲㄸㅉㅃㅏㅑㅓㅕㅗㅛㅜㅠㅢㅐㅔㅒㅖ가-힣0123456789 ' :
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ',
          tessdata_dir: process.env.TESSDATA_PREFIX,
          user_defined_dpi: '300',             // Set DPI explicitly
        });

        const result = await worker.recognize(rotatedImage);
        console.log('Recognition result:', result.data);
        
        if (!result.data.text.trim()) {
          throw new Error('No text was detected in the image');
        }

        // Cache the result
        this.cache.set(cacheKey, result);
        
        // Limit cache size
        if (this.cache.size > 100) {
          const firstKey = this.cache.keys().next().value;
          this.cache.delete(firstKey);
        }

        if (language === 'kor') {
          result.data.text = this.cleanupKoreanText(result.data.text);
        }

        return {
          text: result.data.text,
          confidence: result.data.confidence,
          language,
          words: result.data.words
        };
      } finally {
        await worker.terminate();
      }
    } catch (error) {
      console.error('OCR Error:', error);
      throw new Error(`OCR processing failed: ${error.message}`);
    }
  }

  async preprocessImage(imageFile) {
    try {
      let pipeline = sharp(imageFile.buffer);
      const metadata = await pipeline.metadata();

      // Increase target width for better character recognition
      const targetWidth = 2400; // Increased from 1800 for better detail

      if (metadata.width > targetWidth) {
        pipeline = pipeline.resize(targetWidth, null, {
          fit: 'inside',
          withoutEnlargement: true,
          kernel: sharp.kernel.lanczos3 // Better quality downscaling
        });
      }

      // Enhanced preprocessing pipeline
      pipeline = pipeline
        .grayscale()
        .normalize()
        // Improve contrast more aggressively
        .linear(1.5, -30) // Increased contrast
        .modulate({
          brightness: 1.1,
          contrast: 1.2
        })
        // Adaptive thresholding with better parameters
        .threshold({
          threshold: 160,
          grayscale: true
        })
        // Remove noise
        .median(1);

      return pipeline.toBuffer();
    } catch (error) {
      console.error('Preprocessing error:', error);
      throw new Error(`Image preprocessing failed: ${error.message}`);
    }
  }

  // Helper method to check if image needs rotation
  async detectAndFixRotation(buffer) {
    try {
      const metadata = await sharp(buffer).metadata();
      if (metadata.orientation && metadata.orientation !== 1) {
        return sharp(buffer)
          .rotate()
          .toBuffer();
      }
      return buffer;
    } catch (error) {
      throw new Error(`Rotation detection failed: ${error.message}`);
    }
  }

  // Generate a simple hash of the image content
  async generateImageHash(buffer) {
    const metadata = await sharp(buffer).metadata();
    return `${metadata.width}-${metadata.height}-${buffer.length}`;
  }

  cleanupKoreanText(text) {
    return text
      .replace(/\s+/g, ' ')           // Normalize whitespace
      .replace(/[^\uAC00-\uD7AF\u1100-\u11FF\u3130-\u318F\s0-9]/g, '') // Keep only Korean characters, spaces, and numbers
      .trim();
  }
}

module.exports = new OcrService(); 