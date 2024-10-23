const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user');

const router = express.Router();

router.post('/', async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log(`Attempting to login user with email: ${email}`);

        const user = await User.findOne({ email });
        if (!user) {
            console.log(`No user found with email: ${email}`);
            return res.status(401).json({ message: 'Invalid credentials' });
        }
        console.log(`User found: ${user._id}`);
        console.log(`Incoming password: ${password}`);
        console.log(`Stored hashed password: ${user.password}`);

        const isMatch = await bcrypt.compare(password, user.password);
        console.log(`Password match result: ${isMatch}`);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }
        
        console.log(`Login successful for user: ${user._id}`);
        res.json({ message: 'Login successful' });
    
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;