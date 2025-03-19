const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');

// 책 검색 라우트
router.get('/', async (req, res) => {
    try {
        const { query, type = 'Title', page = 1, size = 20 } = req.query;
        
        if (!query) {
            return res.status(400).json({ error: '검색어를 입력해주세요.' });
        }
        if (query.length < 2) {
            return res.status(400).json({ error: '검색어는 최소 2자 이상이어야 합니다.' });
        }

        if (query.length > 100) {
            return res.status(400).json({ error: '검색어는 100자를 초과할 수 없습니다.' });
        }

        const searchResult = await bookController.searchByTitle(query);
        
        if (!searchResult || !searchResult.item || searchResult.item.length === 0) {
            return res.status(404).json({ error: '검색 결과가 없습니다.' });
        }

        // 검색 결과 목록 반환
        const books = searchResult.item.map(book => ({
            id: book.itemId,
            title: book.title,
            author: book.author,
            publisher: book.publisher,
            isbn: book.isbn13,
            cover: book.cover,
            pubDate: book.pubDate
        }));

        res.json({ 
            message: '검색 성공',
            total: searchResult.totalResults,
            currentPage: parseInt(page),
            totalPages: Math.ceil(searchResult.totalResults / size),
            books: books
        });

    } catch (error) {
        console.error('책 검색 중 오류:', error);
        res.status(500).json({ error: '검색 중 오류가 발생했습니다.' });
    }
});

module.exports = router;