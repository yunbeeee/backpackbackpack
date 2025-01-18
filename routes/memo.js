const express = require('express');
const memoController = require('../controllers/memoController');
const auth = require('../middleware/auth');
const multer = require('multer');
const ocrController = require('../controllers/ocrController');

const router = express.Router();

// Configure multer for file upload
const upload = multer({
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB
  }
});

// Move this test route BEFORE the auth middleware
// Add a test route without auth middleware
router.post('/ocr-test', 
  upload.single('image'),
  ocrController.extractText
);

// Protect all routes after this middleware
router.use(auth);

// Update these routes to match the new structure
router.route('/:bookId/memos')
  .get(memoController.getAllMemos)
  .post(memoController.createMemo);

router.route('/:bookId/memos/:id')
  .get(memoController.getMemo)
  .put(memoController.updateMemo)
  .delete(memoController.deleteMemo);

// Keep your existing routes if still needed
router.get('/reading-books', memoController.getCurrentlyReadingBooks);

router.post('/ocr', 
  upload.single('image'),
  ocrController.extractText
);

module.exports = router;
