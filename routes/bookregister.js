const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');

// 책 검색 및 등록 API
router.post('/register', async (req, res) => {
    try {
        if (!req.body.query || typeof req.body.query !== 'string') {
            return res.status(400).json({ error: '유효한 검색어를 입력해주세요.' });
        }
        
        const bookData = await bookController.fetchBookData(req.body.query);

        if (!bookData || !bookData.item) {
            return res.status(400).json({ error: '책 정보를 불러올 수 없습니다.' });
        }

        const bookInfo = {
            title: bookData.item[0].title,
            author: bookData.item[0].author,
            isbn: bookData.item[0].isbn13,
            publisher: bookData.item[0].publisher,
            genre: bookData.item[0].categoryName,
            category: bookData.item[0].categoryName,
            pageNum: parseInt(bookData.item[0].subInfo.itemPage, 10),
            cover: bookData.item[0].cover
        };

        const newBook = await bookController.registerBook(bookInfo);
        
        if (newBook) {
            return res.status(201).json({ message: '책이 성공적으로 등록되었습니다.', book: newBook });
        } else {
            return res.status(409).json({ error: '이미 등록된 책입니다.' });
        }
    } catch (err) {
        console.error('책 등록 중 오류:', err);
        res.status(500).json({ error: '책 등록 중 오류가 발생했습니다.' });
    }
});

// 모든 책 가져오기 API
router.get('/', async (req, res) => {
  try {
    const books = await bookController.getAllBooks();
    res.status(200).json(books);
  } catch (err) {
    console.error('책 목록 조회 중 오류:', err);
    res.status(500).json({ message: '책 목록을 가져오는 중 오류가 발생했습니다.' });
  }
});

module.exports = router;
