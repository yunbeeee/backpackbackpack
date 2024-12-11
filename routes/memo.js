const express = require('express');
const memoController = require('../controllers/memoController');
const auth = require('../middleware/auth');

const router = express.Router();

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

module.exports = router;
