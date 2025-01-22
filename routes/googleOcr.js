const express = require('express');
const router = express.Router();
const axios = require('axios');
const vision = require('@google-cloud/vision');
const fs = require('fs');
require('dotenv').config();

// Create a client using credentials from env
let credentials;
try {
    credentials = JSON.parse(process.env.GOOGLE_CLOUD_CREDENTIALS);
    // Ensure proper formatting of private_key
    if (credentials.private_key) {
        credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
    }
} catch (error) {
    console.error('Error parsing credentials:', error);
    throw error;
}

const client = new vision.ImageAnnotatorClient({
    credentials: credentials
});

router.post("/extract-text", async (req, res) => {
    const { imageUrl } = req.body;
    const tempImagePath = './temp_image.jpg';

    console.log("Received image URL:", imageUrl);

    if (!imageUrl) {
        return res.status(400).json({ error: "Image URL is required"});
    }

    try {
        console.log("Downloading image from URL:", imageUrl);
        const response = await axios({
            method: 'get',
            url: imageUrl,
            responseType: 'arraybuffer',
            headers: {
                'Accept': 'image/*'
            }
        });
        const buffer = Buffer.from(response.data, 'binary');

        // Save the buffer to a temporary file
        fs.writeFileSync(tempImagePath, buffer);

        // Text extraction through Google Cloud Vision API
        console.log("Extracting text with Google Cloud Vision API...");
        const [result] = await client.textDetection({
            image: {
                content: buffer
            }
        });
        const detections = result.textAnnotations;

        let text = '';
        if (detections && detections.length > 0) {
            text = detections[0].description;
        }

        console.log("Extracted Text:", text);

        // Clean up temporary file
        fs.unlinkSync(tempImagePath);

        res.json({ text });

    } catch (error) {

        console.error("Error processing request:", error);
        res.status(500).json({ error: error.message });

        // Clean up files even if there's an error
        try {
            if (fs.existsSync(tempImagePath)) fs.unlinkSync(tempImagePath);
        } catch (cleanupError) {
            console.error("Error cleaning up files:", cleanupError);
        }

    }
})

module.exports = router;