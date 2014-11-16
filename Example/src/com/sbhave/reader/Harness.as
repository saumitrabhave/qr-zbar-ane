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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/Harness.as
 */

package com.sbhave.reader {
import com.bit101.components.Component;
import com.bit101.components.HBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.Text;
import com.bit101.components.VBox;

import flash.display.Stage;
import flash.events.Event;

public class Harness {

    public static var testStage:Component=null;

    private var _testSource:TestProvider;
    private var _harnessStage:Stage;
    private var window:Component
            ,testVBox:Component
            ,logArea:Text
            ,lblTitle:Label
            ,lblDescription:Label;

    private var testToRun:TestCase=null;

    public function Harness(testSource:TestProvider,harnessStage:Stage) {
        harnessStage.addEventListener(Event.RESIZE, this.handleOrientationChange)
        _harnessStage = harnessStage;
        window = new VBox(harnessStage,10,0);
        lblTitle = new Label(window,0,0,"Title");
        lblTitle.textField.textColor = 0x00AA00;
        lblDescription = new Label(window,0,0,"Description");
        lblDescription.textField.textColor = 0x0000AA;
        testVBox = new VBox(window,0,0);
        logArea = new Text(window,0,0);
        logArea.editable = false;
        logArea.text = "";
        this.reDraw();
        Harness.testStage = testVBox;
        Logger.init(logArea);
        _testSource = testSource;
    }

    public function start():void{
        testToRun = _testSource.getNextTest();
        if(testToRun != null){
            lblTitle.text = testToRun.title;
            lblDescription.text = testToRun.description;
            testToRun.status = TestStatus.RUNNING;
            testToRun.addEventListener(TestCaseEvent.COMPLETE,runNext)
        }else{
            trace("Execution Complete");
        }
    }

    private function runNext(event:TestCaseEvent):void {
        testStage.removeChildren();
        Logger.clear();
        start();
    }

    private function reDraw():void{
        window.setSize(_harnessStage.stageWidth-20,_harnessStage.stageHeight);
        testVBox.setSize(_harnessStage.stageWidth-20,(_harnessStage.stageHeight-100) * 0.65);
        logArea.setSize(_harnessStage.stageWidth-20,(_harnessStage.stageHeight-100) * 0.35 - 5);
    }

    private function handleOrientationChange(event:Event):void {
            this.reDraw();
    }
}
}
