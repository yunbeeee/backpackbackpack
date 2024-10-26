const mongoose = require('mongoose');

const bookSchema = new mongoose.Schema({
  title: { type: String, required: true },
  author: { type: String, required: true },
  isbn: { type: String, required: true },
  publisher: { type: String, required: true },
  genre: { type: String },
  category: { type: String },
  pageNum: { type: Number, required: true },
  cover: { type: String }
});

const Book = mongoose.model('Book', bookSchema);

module.exports = Book;