const express = require('express');
const router = express.Router();
const axios = require('axios');
const fs = require('fs');
const Tesseract = require('node-tesseract-ocr');
const sharp = require('sharp');

router.post("/extract-text", async (req, res) => {
  const { imageUrl } = req.body;
  const imagePath = './downloaded_image.jpg';
  const processedImagePath = './processed_image.jpg';

  console.log("Received imageUrl:", imageUrl);

  if (!imageUrl) {
    return res.status(400).json({ error: "Image URL is required" });
  }

  try {
    console.log("Downloading image from URL:", imageUrl);
    const response = await axios.get(imageUrl, { responseType: 'arraybuffer' });
    const buffer = Buffer.from(response.data);

    console.log("Processing image...");
    await sharp(buffer)
      .resize(800, 600, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .grayscale()
      .sharpen()
      .toFile(processedImagePath);

    console.log("Extracting text with Tesseract...");
    const config = {
      lang: 'kor+eng',
      oem: 1,
      psm: 3,
    };
    
    const text = await Tesseract.recognize(processedImagePath, config);
    console.log('Extracted Text:', text);
    
    // Clean up temporary files
    fs.unlinkSync(processedImagePath);
    
    // Send response to client
    res.json({ text });

  } catch (error) {
    console.error("Error processing request:", error);
    res.status(500).json({ error: error.message });
    
    // Clean up files even if there's an error
    try {
      if (fs.existsSync(processedImagePath)) fs.unlinkSync(processedImagePath);
    } catch (cleanupError) {
      console.error("Error cleaning up files:", cleanupError);
    }
  }
});

module.exports = router; 