const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') }); // Load the dotenv file

const connectDB = async () => {
    try {
        //console.log('Attempting to connect to MongoDB');
        await mongoose.connect(process.env.MONGODB_URI);
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('MongoDB connection error:', error);
        process.exit(1);
    }
}

connectDB().catch(err => console.error('Unhandled error:', err)) // Run the function to check if the connection is successful

module.exports = connectDB;