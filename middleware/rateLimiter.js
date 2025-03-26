const rateLimit = require('express-rate-limit');

const signupLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // Limit each IP to 5 requests per windowMs
    message: "Too many signup attempts from this IP, please try again later."
});

const ocrLimiter = rateLimit({
    windowMs: 1000, // 1 second
    max: 1, // Limit each IP to 1 request per second
    message: "Too many OCR requests, please try again later."
});

// Add new rate limiter for real-time OCR
const realtimeOcrLimiter = rateLimit({
    windowMs: 1000, // 1 second
    max: 2, // Allow 2 requests per second for real-time updates
    message: "Too many real-time OCR requests, please try again later."
});

module.exports = {
    signupLimiter,
    ocrLimiter,
    realtimeOcrLimiter
};