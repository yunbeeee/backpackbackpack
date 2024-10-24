const bcrypt = require('bcrypt');

async function testBcrypt() {
    const password = 'testpassword';
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);
    console.log(`Original password: ${password}`);
    console.log(`Hashed password: ${hash}`);

    const isMatch = await bcrypt.compare(password, hash);
    console.log(`Correct password match: ${isMatch}`);

    const wrongMatch = await bcrypt.compare('wrongpassword', hash);
    console.log(`Wrong password match: ${wrongMatch}`);
}

testBcrypt().catch(console.error);