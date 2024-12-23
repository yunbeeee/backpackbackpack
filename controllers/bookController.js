const Book = require('../models/bookModel');
const axios = require('axios');

// 알라딘 Open API에서 책 정보 가져오기
exports.searchByTitle = async (query) => {
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

// 책 상세 정보 가져오기 함수 추가
exports.getBookDetail = async (itemId) => {
  try {
      const apiUrl = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx";
      const params = {
          ttbkey: process.env.ALADIN_API_KEY,
          ItemId: itemId,
          ItemIdType: 'ItemId',
          Output: 'js',
          Version: '20131101'
      };

      const response = await axios.get(apiUrl, { params });
      if (response.status === 200 && response.data.item) {
          return response.data.item[0];
      }
      return null;
  } catch (err) {
      console.error("책 상세 정보 조회 중 오류:", err);
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

// 사용자의 책 목록을 가져오는 함수
exports.getUserBooks = async (userId) => {
  try {
      // userId에 해당하는 모든 책을 찾아서 반환
      const books = await Book.find({ userId: userId });
      return books;
  } catch (error) {
      console.error('사용자 책 목록 조회 중 오류:', error);
      throw error;
  }
};