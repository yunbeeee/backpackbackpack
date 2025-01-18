const ocrService = require('../services/ocrService');
const catchAsync = require('../utils/catchAsync');

exports.extractText = catchAsync(async (req, res) => {
  try {
    const { language } = req.body;
    const imageFile = req.file;

    // Input validation
    if (!imageFile) {
      return res.status(400).json({
        status: 'error',
        message: 'No image file provided'
      });
    }

    if (!language) {
      return res.status(400).json({
        status: 'error',
        message: 'Language parameter is required'
      });
    }

    const result = await ocrService.processImage(imageFile, language);
    
    res.status(200).json({
      status: 'success',
      data: {
        text: result.text,
        language: result.language,
        confidence: result.confidence,
        words: result.words
      }
    });
  } catch (error) {
    // Handle specific error types
    if (error.message.includes('Invalid file type')) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid file type. Only JPEG and PNG are supported'
      });
    }

    if (error.message.includes('No text was detected')) {
      return res.status(422).json({
        status: 'error',
        message: 'No text could be detected in the image'
      });
    }

    // Generic error handler
    res.status(500).json({
      status: 'error',
      message: 'Error processing image',
      error: error.message
    });
  }
}); 