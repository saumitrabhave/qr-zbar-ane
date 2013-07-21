package com.sbhave.nativeExtensions.zbar
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExtensionContext;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;

    // The application using the Gyroscope extension can create multiple instances of
    // Gyroscope. However, the instances all use a singleton ExtensionContext object.
    //
    // The singleton ExtensionContext object listens for StatusEvent events that
    // the native implementation dispatches. These events contain the device's
    // gyroscope x,y,z data.
    //
    // However, each Gyroscope instance has its own interval timer. When the timer
    // expires, the Gyroscope instance dispatches a GyroscopeEvent that contains
    // the current x,y,z data.
    
    public class Scanner extends EventDispatcher {  
	
		
		private static var extCtx:ExtensionContext = null;
        
        private static var isInstantiated:Boolean = false;
        
        
		
		// Gyroscope constructor
        //
        
        public function Scanner(){ 
			
			if (!isInstantiated){
				extCtx = ExtensionContext.createExtensionContext("com.sbhave.nativeExtensions.zbar", null);
				
				if (extCtx != null){
					
					extCtx.addEventListener(StatusEvent.STATUS, onStatus);
					
				}else{
					throw new Error("Extension not supported");
				} 
			
				isInstantiated = true;
			}
		}
	
        // isSupported()
        //
        // Use this static method to determine whether the device
        // has ability to do barcode scanning. As of now we dont have real world use case
		// where we can not do scanning so just return true.
		// Its good practice to use this function in application right from beginning, so that
		// implementing it in future wont require application code changes.
        
        public static function get isSupported():Boolean {
			if(CONFIG::simulator)
				return false;
			return true; 
		}
        
		//This function is used to set different caliberation and configuration parameters
		//for the Zbar Scanner. Please use Constants defined in Config and Symbology Class 
		// as values for first two parameters. for reference on values to be set or meaning of parameters
		// see http://zbar.sourceforge.net/iphone/sdkdoc/ZBarImageScanner.html#constants
		public function setConfig(symbology:int,config:int,value:int):void{
			extCtx.call("setConfig",symbology,config,value);
		}
		
		// dispose()
        //
		// Call this when application is done with Scanner usage. Note that this method will free-up
		// all the resources held and acquiring those again can be a heavy process. Hence, call this
		// method only when you know that Scanner will not be needed at all or when you are suspending etc.
		// In case your application allows to do scanning again and again DONT call this method after each scan.
        
        public function dispose():void {
			extCtx.dispose();
			extCtx = null;
			isInstantiated = false;
		}
		 
		//reset()
		//
		// If you have calibrated the scanner using setConfig(). Calling this method will put the
		// Scanner to default settings
		
		public function reset():void{
			extCtx.call("reset");
		}
		
		//launch()
		//
		//launches the barcode scanner if not running already.
		//singleScan: if true will fire a DATA event and return to the application UI as soon as Scanner has found
		//at least 1 code. If false, the scanner will never return to the application and will keep firing DATA events
		//only way to bring user back to application is by calling stop() function.
		
		public function launch(singleScan:Boolean):Boolean{
			var ret:Object = extCtx.call("start",singleScan);
			
			if(ret==null)
				return false;
			else
				return ret as Boolean;
		}
        
		// This function sets the size and colors for the target area.
		// This function must be called before calling launch().
		// by default UI will not show any target area.
		public function setTargetArea(size:int, color:String, successColor:String):void{
			extCtx.call("targetArea",size,color,successColor);
		}
		
		
		public function get launched():Boolean
		{
			var ret:Object = extCtx.call("launchStatus");
			
			if(ret==null)
				return false;
			else
				return ret as Boolean;
		}
		
		
		public function stop():Boolean
		{
			var ret:Object = extCtx.call("stop");
			
			if(ret==null)
				return false;
			else
				return ret as Boolean;
		}
		
        // onStatus()
        // Event handler for the event that the native implementation dispatches.
        // The event contains the latest gyroscope x,y,z data.
        //
        
        private function onStatus(e:StatusEvent):void {
			
			trace("Received Event: " + e.code)
			switch(e.code)	{
				case "data":
					dispatchEvent(new ScannerEvent(ScannerEvent.SCAN,e.level));
					break;
			}
		}
	}
}