var app = require('http').createServer(handler)
  , io = require('socket.io').listen(app, {transports:['flashsocket', 'websocket', 'htmlfile', 'xhr-polling', 'jsonp-polling']})
  , fs = require('fs')

app.listen(8085);

function handler (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}

io.sockets.on('connection', function (socket) {

      socket.emit('WelcomeMsg', 'hello world');
  
      socket.on('UP', function (data) {
           console.log(data);
            io.sockets.emit('UP', 'UP');
      });

       socket.on('DOWN', function (data){
           console.log(data);
            io.sockets.emit('DOWN', 'DOWN');
      });

      socket.on('LEFT', function (data){
            console.log(data);
            io.sockets.emit('LEFT', 'LEFT');
      });

      socket.on('RIGHT', function (data){
            console.log(data);
             io.sockets.emit('RIGHT', 'RIGHT');
      });
      
      socket.on('INPUT', function (data){
            console.log(data);
            io.sockets.emit('INPUT', data);
      });
});