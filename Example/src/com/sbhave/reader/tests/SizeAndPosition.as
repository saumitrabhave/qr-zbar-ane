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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/tests/SizeAndPosition.as
 */
package com.sbhave.reader.tests {
import com.sbhave.nativeExtensions.zbar.Config;
import com.sbhave.nativeExtensions.zbar.Scanner;
import com.sbhave.nativeExtensions.zbar.ScannerEvent;
import com.sbhave.nativeExtensions.zbar.Size;
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

public class SizeAndPosition extends TestCase{

    private var s:Scanner;
    private var ctr:int = 0;
    private var currentCam:String = "";
    public function SizeAndPosition() {
        super("Preview Orientation","Verify position and size, Touch preview to stop.");
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
        var qc = new QuestionCommand("Camera Size and Position Correct?",this);
        var bcFront:ButtonCommand = new ButtonCommand("Front Cam",launchFrontPreview,"and observe location and position",qc);
        var bcBack:ButtonCommand = new ButtonCommand("Back Cam",launchBackPreview,"and observe location and position",bcFront);
        return bcBack;
    }

    private function launchBackPreview():void {
        trace("starting Back Cam");
        currentCam = "";
        s.startPreview(currentCam,50,150,300,300);

        var x:Vector.<Size> = s.getAvailablePreviewSizes();
        for each(var sz:Size in x){
            trace("Supported: " + sz.width + "x" + sz.height);
            if(sz.width == 640){
                s.setPreviewSize(sz);
            }
        }

        onResize(new Event("DUMMY")); // Align on Launch
    }

    private function launchFrontPreview():void {
        trace("starting Front Cam");
        currentCam = "front";
        s.startPreview(currentCam);
        s.setDimensions(300,300);
        s.setPosition(50,150);
        onResize(new Event("DUMMY")); //Align on Launch
    }

    private function onTouch(event:ScannerEvent):void {
            s.stopPreview();
    }
}
}
