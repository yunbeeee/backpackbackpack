const catchAsync = require('../utils/catchAsync');
const Memo = require('../models/memoModel');
const client = require('../utils/googleVisionClient');
const axios = require('axios');

// For URL-based OCR
const extractTextFromUrl = catchAsync(async (req, res) => {
  const { imageUrl } = req.body;

  if (!imageUrl) {
    return res.status(400).json({ error: "Image URL is required"});
  }

  try {
    // Download image
    const response = await axios({
      method: 'get',
      url: imageUrl,
      responseType: 'arraybuffer',
      headers: { 'Accept': 'image/*' }
    });
    const buffer = Buffer.from(response.data, 'binary');

    // Process with Google Vision
    const [result] = await client.textDetection({
      image: { content: buffer },
      imageContext: { languageHints: ['ko'] }
    });

    // Return result
    const text = result.textAnnotations[0]?.description || '';
    res.json({ 
      status: 'success',
      data: {
        text,
        confidence: result.textAnnotations[0]?.confidence
      }
    });
  } catch (error) {
    // Error handling
  }
});

// For direct file uploads
const extractText = catchAsync(async (req, res) => {
  try {
    const imageFile = req.file;

    // Input validation
    if (!imageFile) {
      return res.status(400).json({
        status: 'error',
        message: 'No image file provided'
      });
    }

    // Process image with Google Cloud Vision
    const [result] = await client.textDetection({
      image: {
        content: imageFile.buffer
      },
      imageContext: {
        languageHints: ['ko'] // Optimize for Korean text
      }
    });

    // Validate OCR result
    if (!result || !result.textAnnotations || result.textAnnotations.length === 0) {
      return res.status(422).json({
        status: 'error',
        message: 'No text could be detected in the image'
      });
    }

    const text = result.textAnnotations[0].description;
    const cleanedText = text.replace(/\s+/g, ' ').trim();
    
    res.status(200).json({
      status: 'success',
      data: {
        text: cleanedText,
        confidence: result.textAnnotations[0].confidence
      }
    });
  } catch (error) {
    console.error('OCR Error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Error processing image',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// For real-time camera feed
const handleRealtimeText = catchAsync(async (req, res) => {
  try {
    const { imageData } = req.body;

    // Input validation
    if (!imageData) {
      return res.status(400).json({
        status: 'fail',
        message: 'Image data is required'
      });
    }

    // Process image data
    let imageBuffer;
    try {
      imageBuffer = Buffer.from(imageData, 'base64');
    } catch (error) {
      return res.status(400).json({
        status: 'fail',
        message: 'Invalid image data format. Base64 encoded image required.'
      });
    }

    // Use Google Cloud Vision for text detection
    const [result] = await client.textDetection({
      image: {
        content: imageBuffer
      },
      imageContext: {
        languageHints: ['ko']
      }
    });

    // Return just the OCR result
    res.status(200).json({
      status: 'success',
      data: {
        text: result.textAnnotations[0].description,
        confidence: result.textAnnotations[0].confidence,
        imageData  // Include the original image data
      }
    });

  } catch (error) {
    console.error('Real-time OCR error:', error);
    
    if (error.code === 6) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid image format or corrupt image data'
      });
    }

    res.status(500).json({
      status: 'error',
      message: 'Error processing OCR text',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// Update existing memo with new OCR text
const updateMemoText = async (req, res) => {
  try {
    const { memoId, text } = req.body;
    const userId = req.user.id;

    // Validate memo belongs to user
    const memo = await Memo.findOne({
      _id: memoId,
      user: userId
    });

    if (!memo) {
      return res.status(404).json({
        status: 'fail',
        message: 'Memo not found or unauthorized'
      });
    }

    // Update memo
    memo.content = text;
    await memo.save();

    res.status(200).json({
      status: 'success',
      data: {
        memo
      }
    });

  } catch (error) {
    console.error('Memo update error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Error updating memo'
    });
  }
};

// Make sure all functions are included in the exports
module.exports = {
  extractText,
  handleRealtimeText,
  updateMemoText,
  extractTextFromUrl
}; 