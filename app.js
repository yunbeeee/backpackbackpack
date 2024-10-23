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

/*

THIS IS FOR SIGNING UP

*/
app.post('/api/register', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Check if the user already exists
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'Username already exists' });
    }

    // Hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create a new user
    const user = new User({ 
      username, 
      password: hashedPassword 
    });

    await user.save();

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/*

THIS IS FOR LOGGING IN

*/
app.post('/api/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Find the user by username
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    // Compare the provided password with the stored hashed password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    // Generate a JWT token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.json({ token });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

/*

THIS IS FOR PROTECTED ROUTES

*/
app.get('/api/protected', auth, (req, res) => {
  res.json({ message: 'Protected route accessed' });
});

/*

THIS IS FOR RESETTING THE PASSWORD

*/


// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

/*
async function run() {
  try {
    // Connect the client to the server	(optional starting in v4.7)
    await client.connect();
    // Send a ping to confirm a successful connection
    await client.db("admin").command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");
  } finally {
    // Ensures that the client will close when you finish/error
    await client.close();
  }
}
run().catch(console.dir);
*/

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