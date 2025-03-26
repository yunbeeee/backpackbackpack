const mongoose = require('mongoose');

const memoSchema = new mongoose.Schema({
    content: {
        type: String,
        required: [true, 'Memo content is required']
    },
    title: {
        type: String,
        default: '새로운 메모'
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: [true, 'User ID is required']
    },
    book: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Book',
    },
    image: {
        type: String,
    },
    status: {
        type: String,
        enum: ['draft', 'saved'],
        default: 'draft'
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
    if (this.status === 'saved' && !this.book) {
        next(new Error('Book selection is required when saving a memo'));
    }
    this.updatedAt = Date.now();
    next();
});

const Memo = mongoose.model('Memo', memoSchema);

module.exports = Memo;