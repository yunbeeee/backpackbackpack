const express = require('express');
const passport = require('passport');
const NaverStrategy = require('passport-naver').Strategy;
const User = require('../models/user');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const router = express.Router();

passport.use(new NaverStrategy({
    clientID: process.env.NAVER_CLIENT_ID,
    clientSecret: process.env.NAVER_CLIENT_SECRET,
    callbackURL: "http://localhost:3000/api/signup/naver/callback"
}, async (accessToken, refreshToken, profile, done) => {
    try {
        let user = await User.findOne({ naverId: profile.id });
        if (!user) {
            user = new User ({
                naverId: profile.id,
                email: profile.emails[0].value,
                authMethod: 'naver'
            });
            await user.save();
        }
        return done(null, user);
    } catch (error) {
        return done(error);
    }
    
}));

router.get('/', passport.authenticate('naver'));

router.get('/callback',
    passport.authenticate('naver', { failureRedirect: '/login' }),
    (req, res) => {
        res.json({ message: 'Naver signup successful' });
    }
);

module.exports = router;