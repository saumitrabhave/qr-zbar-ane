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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/commands/QuestionCommand.as
 */

/**
 * Created by saumib on 04/11/14.
 */
package com.sbhave.reader.commands {
import com.bit101.components.Component;
import com.bit101.components.HBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.VBox;
import com.sbhave.reader.Command;
import com.sbhave.reader.Harness;
import com.sbhave.reader.TestCase;
import com.sbhave.reader.TestStatus;

import flash.events.Event;

public class QuestionCommand extends Command {

    private var _question:String;
    private var _box:Component;
    private var lblQuestion:Label
                ,btnYes:PushButton
                ,btnNo:PushButton;
    private var _testToRun:TestCase;

    public function QuestionCommand(question:String,runningTest:TestCase) {
        super();
        _question = question;
        _testToRun = runningTest;
    }

    override public function execute():void{
        _box = new VBox(Harness.testStage);
        lblQuestion = new Label(_box,0,0,_question);
        lblQuestion.textField.textColor = 0x00AAAA;
        var hb:HBox = new HBox(_box);
        btnYes = new PushButton(hb,0,0,"Yes",this.handleTestPass);
        btnYes.setSize(100,30);
        btnNo = new PushButton(hb,0,0,"No",this.handleTestFail);
        btnNo.setSize(100,30);
    }

    private function handleTestPass(e:Event):void {
        _testToRun.status = TestStatus.PASS;
    }

    private function handleTestFail(e:Event):void {
        _testToRun.status = TestStatus.FAIL;
    }
}
}
