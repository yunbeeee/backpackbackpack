const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const router = express.Router();

router.post('/', async (req, res) => {
    try {
        const { email, password, username } = req.body;
        console.log(`Attempting to sign up user with email: ${email}`);

        // Check if the user already exists
        const existingUser = await User.findOne({ $or: [{ email }, { username }] });
        if (existingUser) {
            if (existingUser.email === email) {
                console.log(`User with email ${email} already exists`);
                return res.status(400).json({ message: 'User already exists' });
            } else if (existingUser.username === username) {
                console.log(`User with username ${username} already exists`);
                return res.status(400).json({ message: 'User already exists' });
            }
        }

        // Hash the password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);
        
        // Create a new user
        const newUser = new User({
            email,
            password: hashedPassword,
            authMethod: 'email',
            username,
        });

        // Save the user to the database    
        await newUser.save();
        console.log(`New user created with ID: ${newUser._id}`);

        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        console.error('Email signup error:', error);

        // Check if the error is due to a duplicate key
        if (error.code === 11000) {
            return res.status(400).json({ message: 'Email or Username already exists' });
        }
        // If the error is not due to a duplicate key, return a generic error message
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;