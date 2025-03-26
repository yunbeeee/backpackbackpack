const express = require('express');
const memoController = require('../controllers/memoController');
const auth = require('../middleware/auth');
const upload = require('../middleware/upload');  // Import from middleware
const ocrController = require('../controllers/ocrController');

const router = express.Router();

// Use the imported upload middleware
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

// Route for creating memo from camera/OCR
router.post('/camera-memo',
  auth,
  memoController.createMemoFromCamera
);

// Route for saving memo with book
router.post('/save-with-book',
  auth,
  memoController.saveMemoWithBook
);

module.exports = router;
