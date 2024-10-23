const express = require('express');
const passport = require('passport');
const KakaoStrategy = require('passport-kakao').Strategy;
const User = require('../models/user');

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const router = express.Router();

passport.use(new KakaoStrategy({
    clientID: process.env.KAKAO_CLIENT_ID,
    callbackURL: "http://localhost:3000/api/signup/kakao/callback"
}, async (accessToken, refreshToken, profile, done) => {
    try {
        let user = await User.findOne({ kakaoId: profile.id });
        if (!user) {
            user = new User({
                kakaoId: profile.id,
                email: profile._json.kakao_account.email,
                authMethod: 'kakao'
            });
            await user.save();
        }
        return done(null, user);

        
    } catch (error) {
        return done(error);
    }
}));

router.get('/', passport.authenticate('kakao'));

router.get('/callback',
    passport.authenticate('kakao', { failureRedirect: '/login' }),
    (req, res) => {
        res.json({ message: 'Kakao signup successful' });
    }
);

module.exports = router;