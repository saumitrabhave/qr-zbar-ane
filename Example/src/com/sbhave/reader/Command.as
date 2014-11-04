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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/Command.as
 */

package com.sbhave.reader {
import avmplus.getQualifiedClassName;

import com.bit101.components.Component;

import flash.display.Stage;
import flash.events.Event;

import flash.events.EventDispatcher;
import flash.utils.getDefinitionByName;

[Event(name="done", type="flash.events.Event")]
[Event(name="error", type="flash.events.Event")]
public class Command extends EventDispatcher{

    public function Command(nextCommand:Command=null){
        inspectAbstract();
        if(Harness.testStage == null){
            throw new Error("Commands can not be initialized before Harness");
        }
        this.addEventListener("done",handleDone,false,10);
        this.addEventListener("error",handleError,false,10);
        _nextCommand = nextCommand;
    }
    private var _shouldReturnNextCommand:Boolean = false;

    private var _nextCommand:Command = null;

    public function get nextCommand():Command{
        inspectAbstract();
        if(_shouldReturnNextCommand){
            return _nextCommand;
        }else{
            throw new Error("nextCommand can be accessed only after done or error event");
        }
    }

    public function execute():void{
        throw new Error("execute() must be overridden");
    }

    private function inspectAbstract():void
    {
        var className : String = getQualifiedClassName(this);
        if (getDefinitionByName(className) == Command )
        {
            throw new ArgumentError(
                            getQualifiedClassName(this) + " Class is Abstract, extend and call the implementation.");
        }
    }

    private function handleDone(event:Event):void {
        _shouldReturnNextCommand = true;
    }

    private function handleError(event:Event):void {
        _shouldReturnNextCommand = true;
    }

}
}
