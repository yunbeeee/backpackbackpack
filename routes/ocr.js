const express = require('express');
const router = express.Router();
const axios = require('axios');
const fs = require('fs');
const Tesseract = require('node-tesseract-ocr');
const sharp = require('sharp');

router.post("/extract-text", async (req, res) => {
  const { imageUrl } = req.body;
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
      .resize(1200, 1600, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .grayscale()
      .linear(1.5, -0.2)
      .median(1)
      .sharpen({
        sigma: 1.5,
        m1: 1,
        m2: 2,
        x1: 2,
        y2: 10,
        y3: 20
      })
      .threshold(150)
      .resize({ width: 1000 })
      .toFile(processedImagePath);

    console.log("Extracting text with Tesseract...");
    const config = {
      lang: 'kor+eng',
      oem: 1,
      psm: 4,
      dpi: 300,
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