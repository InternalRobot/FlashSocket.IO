package com.internalrobot.socketIO {
	
	import flash.display.Stage; 
	import flash.display.MovieClip; 
	import flash.events.Event;
	import flash.text.TextField;
	
	import app.global.GlobalVars;
	
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;

	
	public class SocketIO extends MovieClip {
		 
		private var theStage:Stage = GlobalVars.STAGE;
		private var hostName:String = GlobalVars.HOST_NAME; 
		private var portNumber:String = GlobalVars.PORT_NUMBER; 
		private var roomname:String; 
		
		private var socket:FlashSocket;
		
		private var textbox:TextBox = new TextBox();
		private var theText:TextField; 
		
		public function SocketIO(){
			// constructor code
		}
		
		public function initSocketIO():void{
			trace('initSocketIO');
			initServerConnection();
		}
		
		private function initServerConnection():void {
			trace(theStage);
			theStage.addChild(textbox); 
			theText = textbox.textbox;
			
			trace("Connecting to server...");
			theText.text = 'Connecting to server...';
			
			socket = new FlashSocket(hostName+":"+portNumber);
			
			socket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
			socket.addEventListener(FlashSocketEvent.IO_ERROR, onError);
			socket.addEventListener(FlashSocketEvent.SECURITY_ERROR, onError);

			socket.addEventListener("WelcomeMsg", onConnection);
		}
		
		public function get socketIO():FlashSocket{
			return socket;
		}
		
		private function onConnection(event:FlashSocketEvent):void {
			trace("Connected!");
			theText.appendText('\nConnected!');
			
			socket.addEventListener('joinRoomResponse', joinRoomResponse);
			socket.addEventListener('helloRoomResponse', helloRoomResponse);
			socket.addEventListener('getRoomResponse', getRoomResponse);
			socket.send(undefined, 'getRoom');
		}
		
		private function getRoomResponse(e:FlashSocketEvent):void{
			trace(e.data);
			roomname = e.data;
			socket.send(roomname, 'joinRoom');
			trace('Joining room...');
			theText.appendText('\njoining room...');
		}
		
		private function joinRoomResponse(e:FlashSocketEvent):void{
			socket.send(roomname, 'helloRoom');
		}
		
		private function helloRoomResponse(e:FlashSocketEvent):void{
			trace('Joined room!');
			theText.appendText('\nJoined Room!');
			trace('hello room!');	
			theText.appendText('\nHello Room!');
		}
		
		private function userConnected():void{
			dispatchEvent(new Event("userConnected"));
		}
		
		private function onConnect(event:FlashSocketEvent):void {
			trace('Connected... Awaiting response...');
			theText.appendText('\nConnected... Awaiting response...');
		}
		
		private function onError(event:FlashSocketEvent):void {
			trace('Error! Something went wrong...');
			theText.appendText('\nError! Something went wrong...');
		}
		
		/*private function sendData(e:AppEvent):void{
			trace('sendData');
			var theData = JSON.stringify(e.object);

			socket.send(theData, 'sendControllerData');
		}*/

	}
	
}
