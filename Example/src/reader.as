/*
 * Copyright (c) 2014 Saumitra R Bhave
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/reader.as
 */

package
{

import com.sbhave.reader.Harness;
import com.sbhave.reader.TestProvider;

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Camera;
import flash.permissions.PermissionStatus;
import flash.events.PermissionEvent;

public class reader extends Sprite
{
    private var _harness:Harness;

    private var c:int = 0;

    private function onStart2(e:MouseEvent):void {
        /*

         */
    }

    public function reader()
    {
        // Set the Stage Properties for nice display.
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.TOP_LEFT;
        var thisStage:Stage = this.stage;
        var app:reader = this;

        //Workaround for blank screen after screen unlock.
        this.stage.addEventListener(Event.ACTIVATE,function(e:Event):void{
            thisStage.quality = StageQuality.MEDIUM;
        });
        this.stage.addEventListener(Event.DEACTIVATE,function(e:Event):void{
            thisStage.quality = StageQuality.LOW;
        });


        // Start the Test Harness
        this.stage.addEventListener(Event.ENTER_FRAME,start);
    }

    private function start(e:Event):void {
        if(c > 1){
            trace("-----APP STARTING-----\n");
            this.stage.removeEventListener(Event.ENTER_FRAME,start);
            var testProvider:TestProvider = new TestProvider();
            _harness = new Harness(testProvider,this.stage);
            _harness.start();
            if (Camera.isSupported) {
                var cam = Camera.getCamera();

                if (Camera.permissionStatus != PermissionStatus.GRANTED)
                {
                    cam.addEventListener(PermissionEvent.PERMISSION_STATUS, function(e:PermissionEvent):void {
                        if (e.status == PermissionStatus.GRANTED) {
                            trace("Camera Permission Granted");
                        } else {
                            trace("Camera Permission Granted");
                        }
                    });

                    try {
                        cam.requestPermission();
                    } catch(e:Error) {
                        trace("Error while asking for cam permissions");
                    }
                }
            }
        }
        c++;
    }
}

}
