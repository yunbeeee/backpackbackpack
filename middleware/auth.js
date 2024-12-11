const jwt = require('jsonwebtoken');

module.exports = function (req, res, next) {
    const authHeader = req.header('Authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'No token, authorization denied' });
    }

    try {
        const token = authHeader.split(' ')[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        console.log('Decoded token:', decoded);  // This will show us the token structure
        
        // Check if we have userId in the decoded token
        if (!decoded.userId) {
            console.log('No userId in token. Full decoded payload:', decoded);
            return res.status(401).json({ message: 'Invalid token structure' });
        }

        req.user = decoded;  // Pass the entire decoded object
        console.log('Set user in request:', req.user);
        next();
    } catch (err) {
        console.log('Token verification error:', err);
        res.status(401).json({ message: 'Token is not valid' });
    }
};

