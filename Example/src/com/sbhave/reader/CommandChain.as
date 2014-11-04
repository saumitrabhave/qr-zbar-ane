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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/CommandChain.as
 */

package com.sbhave.reader {
import flash.events.Event;

public class CommandChain {

    private var _command:Command;
    private var _testCase:TestCase;

    public function CommandChain(command:Command,testCase:TestCase) {
        _command = command;
        _testCase = testCase;
    }

    public function execute():void {
        if(_command != null){
            _command.addEventListener("done",commandDone);
            _command.addEventListener("error",commandError);
            _command.execute();
        }else{
            trace ("Done With All Commands");
        }
    }

    private function commandError(event:Event):void {
       removeListeners();
    }

    private function removeListeners():void {
        _command.removeEventListener("done",commandDone);
        _command.removeEventListener("error",commandError);
    }

    private function commandDone(event:Event):void {
        removeListeners();
        _command = _command.nextCommand;
        execute();
    }
}
}
