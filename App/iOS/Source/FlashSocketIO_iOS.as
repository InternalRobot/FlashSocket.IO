package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import app.global.GlobalVars; 
	
	import com.internalrobot.socketIO.SocketIO;
	
	
	public class FlashSocketIO_iOS extends MovieClip {
		
		private var socketIO:SocketIO; 
		
		public function FlashSocketIO_iOS() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE,init,false,0,true);
		}
		
		private function init(e:Event):void{
			
			//set global stage
			GlobalVars.STAGE = stage; 
			
			//init socketIO
			socketIO = new SocketIO();
			socketIO.initSocketIO();

		}
		
	}
	
}
