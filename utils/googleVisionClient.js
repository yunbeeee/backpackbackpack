const vision = require('@google-cloud/vision');
require('dotenv').config();

// Create a client using credentials from env
let credentials;
try {
    credentials = JSON.parse(process.env.GOOGLE_CLOUD_CREDENTIALS);
    // Ensure proper formatting of private_key
    if (credentials.private_key) {
        credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
    }
} catch (error) {
    console.error('Error parsing Google Cloud credentials:', error);
    throw error;
}

const client = new vision.ImageAnnotatorClient({
    credentials: credentials
});

module.exports = client; 