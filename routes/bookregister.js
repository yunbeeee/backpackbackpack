const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file


// 책 등록 라우트

router.post('/', async (req, res) => {
    try {
        const userId = req.session.userId;
        if (!userId) {
            return res.status(401).json({ error: '로그인이 필요합니다.' });
        }

        const { itemId } = req.body;
        if (!itemId) {
            return res.status(400).json({ error: '책을 선택해주세요.' });
        }

        // 선택한 책의 상세 정보 가져오기
        const bookDetail = await bookController.getBookDetail(itemId);
        if (!bookDetail) {
            return res.status(404).json({ error: '책 정보를 찾을 수 없습니다.' });
        }

        const bookInfo = {
            title: bookDetail.title,
            author: bookDetail.author,
            isbn: bookDetail.isbn13,
            publisher: bookDetail.publisher,
            genre: bookDetail.categoryName,
            category: bookDetail.categoryName,
            pageNum: parseInt(bookDetail.subInfo.itemPage, 10),
            cover: bookDetail.cover,
            status: 'reading',
            startDate: new Date(),
            completedDate: null,
            userId: userId
        };

        const newBook = await bookController.registerBook(bookInfo, userId);
        
        if (newBook) {
            res.status(201).json({ 
                message: '책이 성공적으로 등록되었습니다.',
                book: newBook 
            });
        } else {
            res.status(409).json({ error: '이미 등록된 책입니다.' });
        }

    } catch (err) {
        console.error('책 등록 중 오류:', err);
        res.status(500).json({ error: '책 등록 중 오류가 발생했습니다.' });
    }
});

// 사용자의 책 목록 가져오기 API
router.get('/getall', async (req, res) => {
    try {
        const userId = req.session.userId;
        if (!userId) {
            return res.status(401).json({ error: '로그인이 필요합니다.' });
        }
        const books = await bookController.getUserBooks(userId);
        res.status(200).json(books);
    } catch (err) {
        console.error('책 목록 조회 중 오류:', err);
        res.status(500).json({ message: '책 목록을 가져오는 중 오류가 발생했습니다.' });
    }
});

module.exports = router;
