const path = require('path');

const mysqlConfig = require('./../mysql.json');
const mysql = require('mysql').createConnection(mysqlConfig);

mysql.connect();

const express = require('express');
const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);

app.use(express.static(path.join(__dirname, 'static')));

io.on('connection', function (socket) {
  // TODO
});

http.listen(process.env.PORT || 8080, function () {
  console.log('listening on port ' + http.address().port);
});
