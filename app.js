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

const bodyParser = require('body-parser');
const bookRoutes = require('./routes/bookregister');


const passport = require('passport');
const emailSignupRoutes = require('./routes/emailSignup');
//const appleSignupRoutes = require('./routes/appleSignup');
//const kakaoSignupRoutes = require('./routes/kakaoSignup');
//const naverSignupRoutes = require('./routes/naverSignup');
const loginRoutes = require('./routes/login');

const app = express();
require('dotenv').config();
const uri = process.env.MONGODB_URI; // Get the MongoDB URI from the environment variables

app.use(express.json());
app.use(passport.initialize());
app.use('/api/password', passwordResetRoutes);
app.use('/signup', emailSignupRoutes);
app.use('/login', loginRoutes);
console.log('loginRoutes', loginRoutes);
console.log('emailSignupRoutes', emailSignupRoutes);
//app.use('/api/signup/apple', appleSignupRoutes);
//app.use('/api/signup/kakao', kakaoSignupRoutes);
//app.use('/api/signup/naver', naverSignupRoutes);

//책등록
app.use(bodyParser.json());
app.use('/api/books', bookRoutes);

// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});


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

module.exports = app;