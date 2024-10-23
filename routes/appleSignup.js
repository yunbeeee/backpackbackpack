const express = require('express');
const passport = require('passport');
const AppleStrategy = require('passport-apple');
const User = require('../models/user');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const router = express.Router();

passport.use(new AppleStrategy({
    clientID: process.env.APPLE_CLIENT_ID,
    teamID: process.env.APPLE_TEAM_ID,
    keyID: process.env.APPLE_KEY_ID,
    privateKeyLocation: process.env.APPLE_PRIVATE_KEY_LOCATION,
    callbackURL: "http://localhost:3000/api/signup/apple/callback"
}, async (accessToken, refreshToken, idToken, profile, done) => {
    try {
        let user = await User.findOne({ appleId: profile.id});
        if (!user) {
            user = new User({
                appleId: profile.id,
                email: profile.email,
                authMethod: 'apple'
            });
            await user.save();
        }
        return done(null, user);
    } catch (error) {
        return done(error);
    }

}));

router.get('/', passport.authenticate('apple'));

router.get('/callback',
    passport.authenticate('apple', { failureRedirect: '/login' }),
    (req, res) => {
        res.json({ message: 'Apple signup successful'});
    }
);

module.exports = router;