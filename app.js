const { MongoClient, ServerApiVersion } = require('mongodb');
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const session = require('express-session');
const User = require('./models/user');
const auth = require('./middleware/auth');
const passwordResetRoutes = require('./routes/passwordReset');
const connectDB = require('./config/database');
const mongoose = require('mongoose');
const logger = require('./utils/logger');
const cors = require('cors');

const bodyParser = require('body-parser');
const bookRegisterRouter = require('./routes/bookregister');
const memoRoutes = require('./routes/memo');


const passport = require('passport');
const emailSignupRoutes = require('./routes/emailSignup');
//const appleSignupRoutes = require('./routes/appleSignup');
//const kakaoSignupRoutes = require('./routes/kakaoSignup');
//const naverSignupRoutes = require('./routes/naverSignup');
const loginRoutes = require('./routes/login');

const app = express();
app.use(cors({
  origin: '*', // Be more specific in production
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
require('dotenv').config();
const uri = process.env.MONGODB_URI; // Get the MongoDB URI from the environment variables

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    maxAge: 24 * 60 * 60 * 1000 // change when Flutter app is ready
   }  // HTTPS 사용 시 true
}));

app.use(express.json());
app.use(passport.initialize());

// Signup, Login, Password Reset
app.use('/api/password', passwordResetRoutes);
app.use('/api/signup', emailSignupRoutes);
app.use('/api/auth', loginRoutes);
console.log('loginRoutes', loginRoutes);
console.log('emailSignupRoutes', emailSignupRoutes);
//app.use('/api/signup/apple', appleSignupRoutes);
//app.use('/api/signup/kakao', kakaoSignupRoutes);
//app.use('/api/signup/naver', naverSignupRoutes);

//책등록
app.use(bodyParser.json());
app.use('/api/books', bookRegisterRouter);

//메모
app.use('/api/memos', memoRoutes);

const startServer = async () => {
  try {
    await connectDB(); // from config/database.js
    app.listen(3000, () => {
      console.log('Server is running on port 3000');
    });
  } catch (error) {
    console.error('Could not connect to MongoDB:', error);
    process.exit(1);
  }
}
startServer();

app._router.stack.forEach(function(r){
    if (r.route && r.route.path){
        console.log(r.route.path)
    }
});

module.exports = app;