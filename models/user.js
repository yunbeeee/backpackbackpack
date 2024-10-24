const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Define the user schema
const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    phoneNumber: { type: String, required: true, unique: true },
    password: { type: String },
    username: { type: String, sparse: true, unique: true },
    authMethod: { type: String, required: true },
    signupComplete: { type: Boolean, default: false },
    createdAt: { type: Date, default: Date.now }
});

// Hash the password before saving
userSchema.pre('save', async function(next) {
    if (this.isModified('password')) {
        this.password = await bcrypt.hash(this.password, 10);
    }
    next();
});

const User = mongoose.model('User', userSchema);

module.exports = User;