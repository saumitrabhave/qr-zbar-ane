package
{
	
	import com.sbhave.nativeExtensions.zbar.Config;
	import com.sbhave.nativeExtensions.zbar.Scanner;
	import com.sbhave.nativeExtensions.zbar.ScannerEvent;
	import com.sbhave.nativeExtensions.zbar.Symbology;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class reader extends Sprite
	{
		private const SRC_SIZE:int = 320;
		private const STAGE_SIZE:int = 350;
		
		private var errorView:Sprite;
		private var errorText:TextField = new TextField();
		
		private var startView:Sprite;
		private var startView2:Sprite;
		
		private var cameraView:Sprite;    
		private var camera:Camera;
		private var video:Video = new Video(SRC_SIZE, SRC_SIZE);
		private var freezeImage:Bitmap;
		private var blue:Sprite = new Sprite();
		private var red:Sprite = new Sprite();
		private var blurFilter:BlurFilter = new BlurFilter();
		
		private var resultView:Sprite;
		private var textArea:TextField = new TextField();
		
		private var rect:TextField = new TextField();
		
		public var statusField:TextField;
		
		private var s:Scanner;
		private var c:int = 0;
		private var lastFocus:Number = 0;
		
		
		///////////////////// API Demonstration ///////////////////////////////////////////////////////////////
		//IMPORTANT: Please see the important modification required in reader-app.xml
		// we need to define one actvity in manifest additions.
		
		private function onStart(e:MouseEvent):void {
			
			trace("starting");
			
			// 1. Create a new Scanner() object. Whnever your design allows have only one instance of this 
			s = new Scanner();
			
			// 2. Specify size and colors for target area for barcode scanning. Default is 100px, Red and Green
			s.setTargetArea(350,"0xFF0000FF","0xFFABCDEF");
			
			// 3. Set configs, for eg enable more symbologies, set crop area, or min-max lengths for scanned data 
			s.setConfig(Symbology.EAN13,Config.ENABLE,1);
			
			//4. Add event listenser so that we get notfied whenever a barcode is scanned.
			s.addEventListener(ScannerEvent.SCAN,onScan);
			
			//5. Actually launch the scanning UI, true means UI will automatically close after 1 scan.
			s.launch(true);
			
			// 6. Use launched property to know if the scanner is already running.
			// Optionally call stop() to stop the scanning UI and bring the user back to the app. 
			trace("Launched: " + s.launched); 
			textArea.text += "\nLaunched: " + s.launched;	
			
		}
		
		private function onStart2(e:MouseEvent):void {
			
			trace("starting");   
			s = new Scanner();
			s.setTargetArea(100,"0xFF00FF00","0xFFFFFFFF"); // Values are 0xAARRGGBB [Alpha, Red, Green, Blue]
			s.reset();  // Only QR Code By default
			s.addEventListener(ScannerEvent.SCAN,onScan);
			s.launch(false); // Multiple scans, until user presses back button to come back to the app.
			
			trace("Launched: " + s.launched); 
			textArea.text += "\nLaunched: " + s.launched;
		}
		
		private function onScan(e:ScannerEvent):void{
			// En event handler data property will give you the data that was scanned.
			trace("Got Code: " + e.data);
			textArea.text += "\nGot Code: " + e.data;  
		}
		
		/////////////////////////////////// Boring UI Code ///////////////////////////////////
		public function reader()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.addEventListener(Event.ENTER_FRAME,start);
			
		}
		
		private function start(e:Event):void {
			if(c > 1){
				trace("fired!!!");
				this.stage.removeEventListener(Event.ENTER_FRAME,start);
				startView = buildStartView();
				startView2 = buildStartView2();
				
				resultView = buildResultView();
				
				this.addChild( startView );
				this.addChild( startView2 );
				this.addChild(resultView);
				
				startView.addEventListener(MouseEvent.CLICK, onStart);
				startView2.addEventListener(MouseEvent.CLICK, onStart2);
			}
			c++;
		}
		private function buildStartView():Sprite {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0xAAAAAA], [1.0, 1.0], [0, 255], new Matrix(0, 0.03, -0.03, 0, 0, 15));
			sprite.graphics.lineStyle(2);
			sprite.graphics.drawRoundRect(0, 0, 200, 30, 5);
			
			var btnText:TextField = new TextField();
			btnText.autoSize = TextFieldAutoSize.LEFT;
			btnText.text = "Single Scan";
			btnText.setTextFormat(new TextFormat(null, 16, null, true));
			btnText.selectable = false;
			
			btnText.x = 0.5 * (sprite.width - btnText.width);
			btnText.y = 0.5 * (sprite.height - btnText.height);
			
			sprite.addChild(btnText);      
			sprite.mouseChildren = false;
			sprite.buttonMode = true;
			
			sprite.x = 0;
			sprite.y = 0.5 * (STAGE_SIZE - sprite.height);
			
			return sprite;
		}
		
		private function buildStartView2():Sprite {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0xAAAAAA], [1.0, 1.0], [0, 255], new Matrix(0, 0.03, -0.03, 0, 0, 15));
			sprite.graphics.lineStyle(2);
			sprite.graphics.drawRoundRect(0, 0, 200, 30, 5);
			
			var btnText:TextField = new TextField();
			btnText.autoSize = TextFieldAutoSize.LEFT;
			btnText.text = "Multi Scan";
			btnText.setTextFormat(new TextFormat(null, 16, null, true));
			btnText.selectable = false;
			
			btnText.x = 0.5 * (sprite.width - btnText.width);
			btnText.y = 0.5 * (sprite.height - btnText.height);
			
			sprite.addChild(btnText);      
			sprite.mouseChildren = false;
			sprite.buttonMode = true;
			
			sprite.x = 0;
			sprite.y = 0.5 * (STAGE_SIZE - sprite.height) + 140;
			
			return sprite;
		}
		private function buildResultView():Sprite {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0xDDDDEE, 0xBBBBCC], [0.9, 0.9], [0, 255], new Matrix(0, 0.1, -0.1, 0, 0, 150));
			sprite.graphics.drawRoundRect(0, 0, 280, 280, 20);
			
			sprite.addChild( textArea );
			textArea.width = 250;
			textArea.height = 200;
			textArea.wordWrap = true;
			textArea.multiline = true;
			textArea.border = true;
			textArea.background = true;
			textArea.backgroundColor = 0xFFFFFF;
			textArea.x = textArea.y = 15;
			
			var btnText:TextField = new TextField();
			btnText.autoSize = TextFieldAutoSize.LEFT;
			btnText.text = "CLOSE";
			btnText.selectable = false;
			var btnSprite:Sprite = new Sprite();
			btnSprite.addChild(btnText);
			btnSprite.graphics.lineStyle(1);
			btnSprite.graphics.beginGradientFill(GradientType.LINEAR, [0xEEEEEE, 0xCCCCCC], [0.9, 0.9], [0, 255], new Matrix(0, 0.01, -0.01, 0, 0, 10));
			btnSprite.graphics.drawRoundRect(0, 0, 80, 20, 8);
			btnText.x = 0.5 * (btnSprite.width - btnText.width);
			btnText.y = 0.5 * (btnSprite.height - btnText.height);
			btnSprite.x = 0.5 * ( 280 - 80 );
			btnSprite.y = 240;
			btnSprite.buttonMode = true;
			btnSprite.mouseChildren = false;
			//btnSprite.addEventListener(MouseEvent.CLICK, onClose);
			
			sprite.addChild( btnSprite );
			sprite.addChild( textArea );
			
			sprite.x = 250;
			sprite.y = 00;
			sprite.filters = [new DropShadowFilter(4.0,45,0,0.875)];
			
			return sprite;
		}
		
	}
	
}