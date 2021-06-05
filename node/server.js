process.title = 'sasuru';

var express = require('express');
var app = express();

var server = require('http').createServer(app);
var io = require('socket.io').listen(server);

var redis = require("redis");

server.listen(3010);

// simple logger
app.use(function(req, res, next){
  console.log('%s %s', req.method, req.url);
  next();
});

io.sockets.on('connection', function (socket) {

  socket.on('join-funnel', function(data) {
    console.log("join-funnel: "+data.funnel);
    socket.join(data.funnel);
    socket.broadcast.to(data.funnel).emit("join", {message: data.username + " se a conectado a este embudo."});
  });

  socket.on('leave-funnel', function(data) {
    console.log("leave-funnel: "+data.funnel);
    socket.leave(data.funnel);
    socket.broadcast.to(data.funnel).emit("leave", {message: data.username + " se a desconectado a este embudo."});
  });

  socket.on('push-deal', function(data) {
    console.log("push-deal: "+data.funnel);
    socket.broadcast.to(data.funnel).emit("pull-deal", {deal: data.deal, move: data.move, message: data.username + " a actualizado un negocio."});
  });

  socket.on('push-stage', function(data) {
    console.log("push-stage: "+data.funnel);
    socket.broadcast.to(data.funnel).emit("pull-stage", {stage: data.stage, move: data.move, message: data.username + " a actualizado una etapa."});
  });

  socket.on('push-funnel', function(data) {
    console.log("push-funnel: "+data.funnel);
    socket.broadcast.to(data.funnel).emit("pull-funnel", {funnel: data.funnel_object, message: data.username + " a actualizado una etapa."});
  });

  // unsubscribe from redis if session disconnects
  socket.on('disconnect', function () {
    console.log("user disconnected");
  });

});
