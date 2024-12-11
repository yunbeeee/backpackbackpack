const Memo = require('../models/memoModel');
const Book = require('../models/bookModel');
const catchAsync = require('../utils/catchAsync');

exports.getCurrentlyReadingBooks = catchAsync(async (req, res) => {
    // Get books that the current user is reading
    const books = await Book.find({
        user: req.user.userId,
        status: 'reading'  // Assuming you have a status field in bookModel
    }).select('title author');

    res.status(200).json({
        status: 'success',
        data: books
    });
});

exports.createMemo = catchAsync(async (req, res) => {
    console.log('Book ID from params:', req.params.bookId);
    console.log('User ID from token:', req.user.userId);
    
    // Find book without user filter first to debug
    const anyBook = await Book.findById(req.params.bookId);
    console.log('Book found without user filter:', anyBook);
    
    if (anyBook) {
        console.log('Book userId:', anyBook.userId);
        console.log('Do IDs match?', anyBook.userId.toString() === req.user.userId);
    }

    // Changed the query to match your Book model's field name
    const book = await Book.findOne({
        _id: req.params.bookId,
        userId: req.user.userId  // This should match the field name in your Book model
    });
    console.log('Found book with both conditions:', book); // Add this debug log

    if (!book) {
        return res.status(404).json({
            status: 'fail',
            message: 'Book not found or not authorized'
        });
    }

    // Create the memo
    const memo = await Memo.create({
        content: req.body.content,
        title: req.body.title,
        user: req.user.userId,
        book: req.params.bookId,
        createdAt: new Date(),
        updatedAt: new Date()
    });

    res.status(201).json({
        status: 'success',
        data: memo
    });
});

exports.getAllMemos = catchAsync(async (req, res) => {
    const memos = await Memo.find({ 
        user: req.user.userId,
        book: req.params.bookId
    });
    
    res.status(200).json({
        status: 'success',
        data: memos
    });
});

exports.getMemo = catchAsync(async (req, res) => {
    const memo = await Memo.findOne({
        _id: req.params.id,
        book: req.params.bookId,
        user: req.user.userId
    });

    if (!memo) {
        return res.status(404).json({
            status: 'fail',
            message: 'Memo not found'
        });
    }

    res.status(200).json({
        status: 'success',
        data: memo
    });
});

exports.updateMemo = catchAsync(async (req, res) => {
    // Add updatedAt timestamp to the update
    const updateData = {
        ...req.body,
        updatedAt: new Date()
    };

    const memo = await Memo.findOneAndUpdate(
        {
            _id: req.params.id,
            book: req.params.bookId,
            user: req.user.userId
        },
        updateData,
        {
            new: true,
            runValidators: true
        }
    );

    if (!memo) {
        return res.status(404).json({
            status: 'fail',
            message: 'Memo not found'
        });
    }

    res.status(200).json({
        status: 'success',
        data: memo
    });
});

exports.deleteMemo = catchAsync(async (req, res) => {
    const memo = await Memo.findOneAndDelete({
        _id: req.params.id,
        book: req.params.bookId,
        user: req.user.userId
    });

    if (!memo) {
        return res.status(404).json({
            status: 'fail',
            message: 'Memo not found'
        });
    }

    res.status(204).json({
        status: 'success',
        data: null
    });
});
