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
    type: Schema.Types.ObjectId,  // MongoDB의 ObjectId 타입
    ref: 'User',                  // User 모델 참조
    required: true
  }
});


module.exports = mongoose.model('Book', bookSchema);