/*const crypto = require('crypto');

const generateSecret = (length) => {
  return crypto.randomBytes(length).toString('hex');
};

const secret = generateSecret(32); // 32 bytes = 64 caracteres hexadecimales
console.log(secret);*/

const crypto = require('crypto');

function generateRandomHex(length) {
  return crypto.randomBytes(length).toString('hex').toUpperCase();
}

const DevEUI = generateRandomHex(8); // 8 bytes = 16 caracteres hexadecimales
const AppEUI = generateRandomHex(8);
const AppKey = generateRandomHex(16); // 16 bytes = 32 caracteres hexadecimales

console.log("DevEUI:", DevEUI);
console.log("AppEUI:", AppEUI);
console.log("AppKey:", AppKey);