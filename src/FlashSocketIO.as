//*****************************
//REQUIRES FLEX 4.5.1
//FLASH PLAYER VERSION 10.2
//*****************************

package {
	
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.ui.Keyboard;
	
	[SWF(width=1000,height=800)]
	
	public class FlashSocketIO extends MovieClip{
		
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		
		protected var socket:FlashSocket;
		protected var chat:MovieClip;
		
		public function FlashSocketIO() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE,loadAssets,false,0,true);
		}
		
		protected function loadAssets(e:Event):void{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate=30;
			stage.quality='high';
			
			var myLoader:Loader = new Loader();
			var myUrlReq:URLRequest = new URLRequest("modules/chat/chatBox.swf");
			myLoader.load(myUrlReq);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, addModule);
		}
	
		protected function addModule(e:Event):void{
			var moduleRef:Class = e.target.applicationDomain.getDefinition("ChatModule") as Class;		
			chat = new moduleRef() as MovieClip;
			chat.x = stage.stageWidth/2 - chat.width/2; 
			chat.y = stage.stageHeight/2 - chat.height/2;
			addChild(chat);
			initServerConnection();
		}
		
		protected function initServerConnection():void {
			
			socket = new FlashSocket("www.internalrobot.com:8085");
			//socket = new FlashSocket("localhost:8085");
			socket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
			socket.addEventListener(FlashSocketEvent.MESSAGE, onMessage);
			socket.addEventListener(FlashSocketEvent.IO_ERROR, onError);
			socket.addEventListener(FlashSocketEvent.SECURITY_ERROR, onError);
			
		
			
			ExternalInterface.call( "console.log" , "Connecting to server...");
			chat.outputtext.appendText("Connecting to server...");
			
			socket.addEventListener("WelcomeMsg", WelcomeMsgHandler);
			
			socket.addEventListener("UP", upHandler);
			socket.addEventListener("DOWN", downHandler);
			socket.addEventListener("LEFT", leftHandler);
			socket.addEventListener("RIGHT", rightHandler);
			socket.addEventListener("INPUT", inputHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}
		
		
		protected function WelcomeMsgHandler(event:FlashSocketEvent):void {
			//Alert.show('we got a custom event!');
			ExternalInterface.call( "console.log" , event.data);
			chat.outputtext.appendText("\nConnected!");
			/*var obj:Object = event.data;
			for (var i:* in obj){
				ExternalInterface.call( "console.log" , obj);
			}*/
		
		}
		
		protected function onConnect(event:FlashSocketEvent):void {
			ExternalInterface.call( "console.log" , "Connected... Awaiting response...");
			chat.outputtext.appendText("\nConnected... Awaiting response...");
			//clearStatus();
			
		}
		
		protected function onError(event:FlashSocketEvent):void {
			ExternalInterface.call( "console.log" , "something went wrong");
			chat.outputtext.appendText("\nError: Connection failed!");
			//setStatus("something went wrong");	
		}
		
		protected function setStatus(msg:String):void {
			ExternalInterface.call( "console.log" , msg);
			
			//status.text = msg;
			
		}
		protected function clearStatus():void {
			ExternalInterface.call( "console.log" , "-");
			chat.outputtext.appendText("Connected!");
			//status.text = "";
		//	this.currentState = "";
			
		}
		
		protected function onMessage(event:FlashSocketEvent):void {
			ExternalInterface.call( "console.log" , "onMessage: " + event.data);
		//	trace('we got message: ' + event.data);
			socket.send({msgdata: event.data},"my other event");
			
		}
		
		protected function inputHandler(e:FlashSocketEvent):void{
			chat.outputtext.appendText("\n"+e.data);	
		}
		
		protected function upHandler(e:FlashSocketEvent):void{
			ExternalInterface.call( "console.log" , e.data);
		}
		
		protected function downHandler(e:FlashSocketEvent):void{
			ExternalInterface.call( "console.log" , e.data);
		}
		
		protected function leftHandler(e:FlashSocketEvent):void{
			ExternalInterface.call( "console.log" , e.data);
		}
		
		protected function rightHandler(e:FlashSocketEvent):void{
			ExternalInterface.call( "console.log" , e.data);
		}
		
		protected function onKeyUp(e:KeyboardEvent):void{
			var key:uint = e.keyCode;
			switch (key) {
				case Keyboard.UP :
				//	socket.send("UP");
					break;
				case Keyboard.DOWN :
				//	socket.send("DOWN");
					break;
				case Keyboard.LEFT :
				//	socket.send("LEFT");
					break;
				case Keyboard.RIGHT :
				//	socket.send("RIGHT");
					break;
				case Keyboard.ENTER :
					//	socket.send("RIGHT");
					break;
			}
		}
		
		protected function onKeyDown(e:KeyboardEvent):void{
			var key:uint = e.keyCode;
			switch (key) {
				case Keyboard.UP :
					socket.send("UP","UP");
					//socket.send("UP");
					break;
				case Keyboard.DOWN :
					socket.send("DOWN","DOWN");
					break;
				case Keyboard.LEFT :
					socket.send("LEFT","LEFT");
					break;
				case Keyboard.RIGHT :
					socket.send("RIGHT","RIGHT");
					break;
				case Keyboard.ENTER :
					//socket.send("INPUT", chat.inputtext.text);
					socket.send(chat.inputtext.text, "INPUT");
					chat.inputtext.text = "";
					break;
			}
		}
		
	}
	
}