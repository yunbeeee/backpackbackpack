const mongoose = require('mongoose');

const memoSchema = new mongoose.Schema({
    content: {
        type: String,
        required: [true, 'Memo content is required']
    },
    title: {
        type: String,
        default: '제목을 입력하세요'
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: [true, 'User ID is required']
    },
    book: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Book',
        required: [true, 'Book ID is required']
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    updatedAt: {
        type: Date,
        default: Date.now
    }
});

// Middleware to update the 'updatedAt' field on save
memoSchema.pre('save', function(next) {
    this.updatedAt = Date.now();
    next();
});

const Memo = mongoose.model('Memo', memoSchema);

module.exports = Memo;