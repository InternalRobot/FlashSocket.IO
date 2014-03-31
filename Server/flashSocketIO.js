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
  //emits an object {objectdata}
  var roomname;
  var theData; 

  socket.emit('WelcomeMsg', 'hello world');


  socket.on('createRoom', function(){ 
    roomname = makeid();
    socket.room = roomname;
    socket.join(roomname);
    socket.emit("createRoomResponse", socket.room);
    console.log(roomname);
  });

  socket.on('getRoom', function(roomname){
    console.log('getRoom');
    socket.emit('getRoomResponse', roomname)
  });
  
  socket.on('joinRoom', function(roomname){
    socket.room = roomname;
    socket.join(roomname);
    io.sockets.in(roomname).emit('joinRoomResponse', socket.room);
    console.log(roomname);
  });

  socket.on('helloRoom', function(roomname){
    console.log('helloRoom');
    io.sockets.in(roomname).emit('helloRoomResponse', 'hello room');
  });

  socket.on('sendData', function(theData){
    console.log('sendData', theData);
    io.sockets.in(roomname).emit('sendDataResponse', theData);
  });
  
});

function makeid(){
    var text = "";
    //no 0 or O;
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    
    return text;
}