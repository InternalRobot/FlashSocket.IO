package app.global  {
	
	import flash.display.Stage;
	
	public class GlobalVars {

		//const
		public static const HOST_NAME:String 		= 'http://internalrobot.com';
		public static const PORT_NUMBER:String 		= '8085';
			
		//vars 
		public static var STAGE:Stage = undefined;
		
		public function GlobalVars() {
			// constructor code
			trace('GlobalVars');
		
		}

	}
	
}

		