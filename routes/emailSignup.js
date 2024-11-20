const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user');
const validator = require('validator');
const signupLimiter = require('../middleware/rateLimiter');
const logger = require('../utils/logger');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const router = express.Router();

// Function to validate email
function validateEmail(email) {
    return validator.isEmail(email);
}

// Step 1: Initial signup with (1) name, (2) phone number, (3) email
router.post('/initial', async (req, res) => {
    try {
        const { name, phoneNumber, email } = req.body;
        console.log(`Attempting initial signup for user with email: ${email}`);

        // Validate email format
        if (!validateEmail(email)) {
            return res.status(400).json({ message: 'Invalid email format' });
        }
        
        // Check if the user already exists
        const existingUser = await User.findOne({ $or: [{ email }, { phoneNumber }] });
        if (existingUser) {
            if (existingUser.email === email) {
                console.log(`User with email ${email} already exists`);
                return res.status(400).json({ message: 'User already exists' });
            } else if (existingUser.phoneNumber === phoneNumber) {
                console.log(`User with phone number ${phoneNumber} already exists`);
                return res.status(400).json({ message: 'User already exists' });
            }
        }

        // Create a new user with initial information
        const newUser = new User({
            name,
            phoneNumber,
            email,
            authMethod: 'email',
            signupComplete: false,
        });

        // Save the user to the database
        const savedUser = await newUser.save();

        res.status(201).json({ message: 'Initial signup successful', userId: savedUser._id });

    } catch (error) {
        console.error('Initial signup error:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// Function to validate password strength
function validatePassword(password) {
    const minLength = 10;
    const hasUpperCase = /[A-Z]/.test(password);
    const hasNumber = /\d/.test(password);
    //const hasSpecialChar = /[^\w]/.test(password);

    if (password.length < minLength) {
        return { isValid: false, message: 'Password must be at least 10 characters long' };
    }

    if (!hasUpperCase) {
        return { isValid: false, message: 'Password must contain at least one uppercase letter' };
    }

    if (!hasNumber) {
        return { isValid: false, message: 'Password must contain at least one number' };
    }

    //if (!hasSpecialChar) {
    //    return { isValid: false, message: 'Password must contain at least one special character' };
    //}

    return { isValid: true };
}


// Step 2: Set username
router.post('/set-username', async (req, res) => {
    try {
        const { userId, username } = req.body;
        console.log(`Attempting to set username for user with ID: ${userId}`);

        // Find the user by ID
        const user = await User.findById(userId);
        if (!user) {
            console.log(`User with ID ${userId} not found`);
            return res.status(404).json({ message: 'User not found' });
        }

        // Check if the username is already taken
        const existingUsername = await User.findOne({ username });
        if (existingUsername) {
            console.log(`Username ${username} already taken`);
            return res.status(400).json({ message: 'Username already taken' });
        }

        // Update the user with the username
        user.username = username;

        // Save the updated user to the database
        await user.save();

        res.status(200).json({ message: 'Username set successfully' });
    } catch (error) {
        console.error('Set username error:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// Step 3: Complete signup with password
router.post('/complete', async (req, res) => {
    try {
        const { userId, password } = req.body;
        console.log(`Attempting to complete signup for user with ID: ${userId}`);

        // Validate the password
        const passwordValidation = validatePassword(password);
        if (!passwordValidation.isValid) {
            console.log('Password validation failed:', passwordValidation.message);
            return res.status(400).json({ message: passwordValidation.message });
        }

        // Find the user by ID
        const user = await User.findById(userId);
        if (!user) {
            console.log(`User with ID ${userId} not found`);
            return res.status(404).json({ message: 'User not found' });
        }

        // Check if the username has been set
        if (!user.username) {
            return res.status(400).json({ message: 'Username must be set before completing signup' });
        }

        // Update the user with password
        user.password = password;
        user.signupComplete = true;

        // Save the updated user to the database
        await user.save();

        return res.status(200).json({ message: 'Signup completed successfully' });
    } catch (error) {
        console.error('Complete signup error:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;
