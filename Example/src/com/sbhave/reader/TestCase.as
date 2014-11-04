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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/TestCase.as
 */
package com.sbhave.reader {
import avmplus.getQualifiedClassName;

import com.bit101.components.Component;

import flash.events.Event;

import flash.events.EventDispatcher;

import flash.utils.getDefinitionByName;


public class TestCase extends EventDispatcher {

    private var _commandChanin:CommandChain;

    public function TestCase(title:String,description:String) {
        inspectAbstract();
        this.addEventListener(TestCaseEvent.STATUS_CHANGE,onStatusChange);
        _title = title;
        _description = description;
    }
    private var _status:String = TestStatus.UNKNOWN;

    public function set status(result:String):void{
        var old:String = _status;
        _status = result;
        dispatchEvent(new TestCaseEvent(TestCaseEvent.STATUS_CHANGE,old,_status));
    }

    private var _description:String;

    public function get description():String{
        return _description;
    }

    private var _title:String;

    public function get title():String{
        return _title;
    }

    private function run():void{
        initialize();
        _commandChanin = new CommandChain(getCommand(),this);
        if(_commandChanin != null){
            _commandChanin.execute();
        }else{
            throw new Error("CommandChain not initialized and set");
        }

    }

    protected function getCommand():Command {
        throw new ArgumentError("getCommand() Must Be Overridden");
    }

    protected function initialize():void{
        throw new ArgumentError("initialize() Must Be Overridden");
    }

    protected function destroy():void{
        throw new ArgumentError("destroy() Must Be Overridden");
    }

    private function inspectAbstract():void
    {
        var className : String = getQualifiedClassName(this);
        if (getDefinitionByName(className) == TestCase )
        {
            throw new ArgumentError(
                            getQualifiedClassName(this) + " Class is Abstract, extend and call the implementation.");
        }
    }

    private function onStatusChange(event:TestCaseEvent):void {
        switch (event.newState){
            case TestStatus.RUNNING:
                if(event.oldState == TestStatus.UNKNOWN || event.oldState == TestStatus.WAITING){
                    this.run();
                }else if(event.oldState == TestStatus.RUNNING){
                    this.destroy();
                    this.run();
                }
                break;
            case TestStatus.ERROR:
            case TestStatus.PASS:
            case TestStatus.FAIL:
                if(event.oldState == TestStatus.RUNNING){
                     trace(_title + " : " + event.newState);
                    this.destroy();
                    dispatchEvent(new TestCaseEvent(TestCaseEvent.COMPLETE,TestStatus.UNKNOWN,event.newState));
                } else {
                    throw new Error("Test has not been executed yet")
                }
                break;
        }
    }
}
}
