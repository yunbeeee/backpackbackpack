const express = require('express');
const router = express.Router();
const ocrController = require('../controllers/ocrController');
const auth = require('../middleware/auth');
const { ocrLimiter, realtimeOcrLimiter } = require('../middleware/rateLimiter');
const client = require('../utils/googleVisionClient');
const upload = require('../middleware/upload');

// Make client available to controllers
router.use((req, res, next) => {
    req.visionClient = client;
    next();
});

// Apply rate limiting and auth middleware
router.use(auth);

router.post("/extract-text", 
    ocrLimiter,
    ocrController.extractText
);

// Handle real-time OCR text
router.post('/realtime', 
    realtimeOcrLimiter,
    ocrController.handleRealtimeText
);

// Update existing memo with new OCR text
router.put('/memo/:memoId', 
    realtimeOcrLimiter,
    ocrController.updateMemoText
);

// URL-based OCR (previously in googleOcr.js)
router.post('/extract-from-url', 
    ocrLimiter,
    ocrController.extractTextFromUrl
);

// File upload OCR
router.post('/extract-from-file', 
    ocrLimiter,
    upload.single('image'),
    ocrController.extractText
);

module.exports = router; 