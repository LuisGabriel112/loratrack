const { log } = require('node:console');
const http = require('node:http');

const hostname = '192.168.1.73';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200; 
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello, World!\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);

  console.log("xd");
  console.log("www");
  
});