const crypto = require('crypto');

const generateSecret = (length) => {
  return crypto.randomBytes(length).toString('hex');
};

const secret = generateSecret(32); // 32 bytes = 64 caracteres hexadecimales
console.log(secret);