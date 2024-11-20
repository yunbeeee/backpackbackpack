const Book = require('../models/bookModel');
const axios = require('axios');

// 알라딘 Open API에서 책 정보 가져오기
exports.fetchBookData = async (query) => {
  try {
    const apiUrl = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx";
    const params = {
      ttbkey: process.env.ALADIN_API_KEY,
      Query: query,
      QueryType: "Title",
      MaxResults: 10,
      start: 1,
      SearchTarget: "Book",
      output: "js",
      Version: "20131101"
    };

    const response = await axios.get(apiUrl, { params });
    if (response.status === 200) {
      return response.data;
    } else {
      return null;
    }
  } catch (err) {
    console.error("알라딘 API 호출 중 오류 발생:", err);
    return null;
  }
};

// 책 데이터베이스에 등록
exports.registerBook = async (bookInfo, userId) => {  // userId 파라미터 추가
  try {
    const existingBook = await Book.findOne({ 
      isbn: bookInfo.isbn,
      userId: bookInfo.userId  // 같은 사용자의 동일한 책만 체크
    });
    
    if (existingBook) {
      return null;
    }

    let pageNum = 0;
    if (bookInfo.item && bookInfo.item[0]?.subInfo?.itemPage) {
      pageNum = parseInt(bookInfo.item[0].subInfo.itemPage);
    } else if (bookInfo.subInfo?.itemPage) {
      pageNum = parseInt(bookInfo.subInfo.itemPage);
    }

    const newBook = new Book({
      ...bookInfo,
      pageNum: pageNum,
      userId: userId  // 사용자 ID 추가
    });
    
    await newBook.save();
    return newBook;
  } catch (err) {
    console.error("책 등록 중 오류 발생:", err);
    throw err;
  }
};

// 모든 책 가져오기
exports.getAllBooks = async () => {
  try {
    const books = await Book.find();
    return books;
  } catch (err) {
    console.error("책 목록 가져오기 중 오류 발생:", err);
    throw err;
  }
};
