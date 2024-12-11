const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user');

const router = express.Router();

router.post('/login', async (req, res) => {
    try {
        const { login, password } = req.body;
        console.log(`Attempting to login user with login: ${login}`);

        // Check if the login is an email or a username
        const isEmail = /\S+@\S+\.\S+/.test(login);

        // Find the user by email or username
        const user = await User.findOne(
            isEmail ? { email: login } : { username: login }
        );

        // If the user is not found, return an error
        if (!user) {
            console.log(`No user found with email: ${isEmail ? 'email' : 'username'}: ${login}`);
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        console.log(`User found: ${user._id}`);

        // Compare the password
        const isMatch = await bcrypt.compare(password, user.password);
        console.log(`Password match result: ${isMatch}`);

        // If the password is incorrect, return an error
        if (!isMatch) {
            return res.status(401).json({ message: 'Incorrect Password' });
        }
        
        console.log(`Login successful for user: ${user._id}`);

        req.session.userId = user._id;

        // Return the user information
        res.json({ 
            message: 'Login successful',
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                username: user.username
            }
        });
    
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;