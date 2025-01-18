module.exports = {
  supportedLanguages: ['eng', 'kor'],
  uploadLimits: {
    fileSize: 5 * 1024 * 1024, // 5MB
    allowedTypes: ['image/jpeg', 'image/png']
  },
  tesseractConfig: {
    workerPath: process.env.TESSDATA_PREFIX,
    cacheSize: 100,
    preprocessingOptions: {
      targetWidth: 1800,
      threshold: 140,
      contrast: 1.2
    }
  }
}; 