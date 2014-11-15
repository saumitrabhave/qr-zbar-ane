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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/tests/PreviewOrientation.as
 */
package com.sbhave.reader.tests {
import com.sbhave.nativeExtensions.zbar.Config;
import com.sbhave.nativeExtensions.zbar.Scanner;
import com.sbhave.nativeExtensions.zbar.ScannerEvent;
import com.sbhave.nativeExtensions.zbar.Symbology;
import com.sbhave.reader.Command;
import com.sbhave.reader.Harness;
import com.sbhave.reader.Logger;
import com.sbhave.reader.TestCase;
import com.sbhave.reader.commands.ButtonCommand;
import com.sbhave.reader.commands.QuestionCommand;

import flash.display.Screen;

import flash.display.Stage;
import flash.display.StageOrientation;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.StageOrientationEvent;
import flash.events.StageOrientationEvent;

public class PreviewOrientation extends TestCase{

    private var s:Scanner;
    private var ctr:int = 0;
    private var currentCam:String = "";
    public function PreviewOrientation() {
        super("Preview Orientation","Verify that Camera Orientation is aligned with screen");
    }

    override protected function initialize():void{
        // 1. Create a new Scanner() object. Whnever your design allows have only one instance of this
        s = new Scanner();
        s.addEventListener(ScannerEvent.PREVIEW_TOUCH,onTouch);
        if(Stage.supportsOrientationChange){
            Harness.testStage.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onChanging);
            Harness.testStage.stage.addEventListener(Event.RESIZE, onResize);
        }
    }

    /**
     * Rotate the Camera Preview whenever Screen Resize (i.e. Orientation Change!!! ??? See Below)
     * The implementation is inspired from
     * http://developer.android.com/reference/android/hardware/Camera.html#setDisplayOrientation(int)
     */
    private function onResize(event:Event):void {
        var degrees:int=0;
        var stageOrientation:String = Harness.testStage.stage.orientation;
        if(event.type.indexOf("sbhave.changing.") !=  -1){
            var arr:Array = event.type.split(".");
            stageOrientation = arr[arr.length - 1];
        }
        trace("Orientation is " +stageOrientation);
        var camRot: int = s.getCameraOrientation(currentCam);
        trace("Camera Rotation is " + camRot);
        switch(stageOrientation){
            case StageOrientation.DEFAULT:
                degrees = 0;
                break;
            case StageOrientation.ROTATED_LEFT:
                degrees = 270;
                break;
            case StageOrientation.UPSIDE_DOWN:

                return;
                degrees = 180;
                break;
            case StageOrientation.ROTATED_RIGHT:
                degrees = 90;
                break;

        }
        if(currentCam == "front"){
            degrees = (camRot + degrees) % 360;
            degrees = (360 - degrees) % 360;  // compensate the mirror
        }else{
            degrees = (camRot - degrees + 360) % 360;
        }

        trace("Setting Camera Orientation: " + degrees);
        s.setCameraOrientation(degrees);
    }

    /**
     * What the hell, dint I just say that I am using the Resize event to align Camera Preview
     * orientation with that of screen? Why am I handling Orientation Change again then?
     * Well I wish things were simpler, but read on...
     *
     * Problems:
     * 1. Stage_Orientation_Change event is fired regardless of the stage orientation change, WTF?
     * Yes, its actually a device orientation than a stage orientation. Eg. Many Mobile Phones
     * Do not support UPSIDE_DOWN orientation, in such case your stage will remain in landscape
     * (or whatever it was bfore you turned your device UPSIDE_DOWN) but you will still get
     * Stage Orientation Change Event, and you will end up seeing wrong things on screen.
     *
     *  Ok So, isn't this the reason we used resize event to avoid issue? Yes, But now
     *  its time for Resize event behaviour.
     *
     *  2. Resize, Event is not fired when you move from landscape to landscape
     *  (Eg. rotatedLeft to rotatedRight) or from portrait to portrait(Makes sense because
     *  stage size is not changing its just rotating). Combine this behaviour with (1),
     *  when you move your phone(which doesn't have Upside_Down by default ^^ )
     *  In all orientations clockwise you essentially move your stage from landscape to
     *  landscape (because there is not upside down)
     *
     *  Hence in the (Device) Orientation Change event, I see if we are moving from
     *  same aspectRatio to same aspectRatio(portrait) and call resize functionality manually
     *  to bring the Camera Preview Orientation in sync with the stage.
     *
     *  ^^ In Native Android you can force reverse Orientation support by using screenOrientation
     *  Activity Manifest attribute, as mentioned at
     *  http://developer.android.com/guide/topics/manifest/activity-element.html#screen . but in AIR
     *  it seems to be a reserved attribute as per
     *  http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-5d0f4f25128cc9cd0cb-7ffc.html#WS2d929364fa0b8137-456dc20c12a43aefb00-8000
     */
    private function onChanging(event:StageOrientationEvent):void {
        var beforeOrientation:String = Harness.testStage.stage.orientation;
        trace("Before: "+event.beforeOrientation + " After: " + event.afterOrientation);
        if(
        (beforeOrientation == StageOrientation.DEFAULT && event.afterOrientation == StageOrientation.UPSIDE_DOWN)
        ||
        (beforeOrientation == StageOrientation.UPSIDE_DOWN && event.afterOrientation == StageOrientation.DEFAULT)
        ||
        (beforeOrientation == StageOrientation.ROTATED_LEFT && event.afterOrientation == StageOrientation.ROTATED_RIGHT)
        ||
        (beforeOrientation == StageOrientation.ROTATED_RIGHT && event.afterOrientation == StageOrientation.ROTATED_LEFT)
        ){
            onResize(new Event("sbhave.changing."+event.afterOrientation));
        }
    }

    override protected function  destroy():void{
        s.removeEventListener(ScannerEvent.PREVIEW_TOUCH,onTouch);
        if(Stage.supportsOrientationChange){
            Harness.testStage.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onChanging);
            Harness.testStage.stage.removeEventListener(Event.RESIZE, onResize);
        }
        s.dispose();
        s = null;
    }

    override protected function getCommand():Command{
        var qc = new QuestionCommand("Did Camera aligned naturally?",this);
        var bcFront:ButtonCommand = new ButtonCommand("Front Cam",launchFrontPreview,"and rotate the device in all modes, Click on preview to exit",qc);
        var bcBack:ButtonCommand = new ButtonCommand("Back Cam",launchBackPreview,"and rotate the device in all modes, Click on preview to exit",bcFront);
        return bcBack;
    }

    private function launchBackPreview():void {
        trace("starting Back Cam");
        currentCam = "";
        s.startPreview(currentCam); // Multiple scans, until user presses back button to come back to the app.
        onResize(new Event("DUMMY")); // Align on Launch
    }

    private function launchFrontPreview():void {
        trace("starting Front Cam");
        currentCam = "front";
        s.startPreview(currentCam); // Multiple scans, until user presses back button to come back to the app.
        onResize(new Event("DUMMY")); // Align on Launch
    }

    private function onTouch(event:ScannerEvent):void {
            s.stopPreview();
    }
}
}
