const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const bookSchema = new Schema({
  title: { type: String, required: true },
  author: { type: String, required: true },
  isbn: { type: String, required: true },
  publisher: { type: String, required: true },
  genre: { type: String },
  category: { type: String },
  pageNum: { type: Number, required: true },
  cover: { type: String },
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['reading', 'completed'],
    default: 'reading'
  },
  startDate: {
    type: Date,
    default: null
  },
  completedDate: {
    type: Date,
    default: null
  },
  memos: [{
    type: Schema.Types.ObjectId,
    ref: 'Memo'
  }]
}, {
  timestamps: true
});

const Book = mongoose.model('Book', bookSchema);

module.exports = Book;