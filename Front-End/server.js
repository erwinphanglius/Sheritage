var express = require('express');

var app = express();
app.use(express.static(__dirname));
app.listen('3300');
console.log('running at\nhttp://localhost:3300');