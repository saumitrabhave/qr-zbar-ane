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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/commands/ButtonCommand.as
 */
package com.sbhave.reader.commands {
import com.bit101.components.Component;
import com.bit101.components.HBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.sbhave.reader.Command;
import com.sbhave.reader.Harness;

import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;

public class ButtonCommand extends Command{

    private var _button:PushButton,_hbox:Component;
    private var _label:String;
    private var _callback:Function;
    private var _description:String;

    public function ButtonCommand(label:String,clickCallback:Function,description:String="",nextCommand:Command=null) {
        super(nextCommand);
        _button = new PushButton();
        _label = label;
        _callback = clickCallback;
        _description = description;
    }

    override public function execute():void{
        _hbox = new HBox();
        var lblDesc:Label = new Label(_hbox,0,0,_description);
        _hbox.addChild(_button);
        _hbox.addChild(lblDesc);

        _hbox.setSize(Harness.testStage.width,0);

        Harness.testStage.addChild(_hbox);
        _button.move(0,0);
        _button.label = _label;
        _button.setSize(150,30);
        _button.addEventListener(MouseEvent.CLICK,onButtonClick);

    }

    private function onButtonClick(e:MouseEvent):void{
        Harness.testStage.removeChild(_hbox);
        try{
            _callback();
            dispatchEvent(new Event("done"));
        }catch(err:Error){
            dispatchEvent(new Event("error"));
        }
    }

    override public function get nextCommand():Command{
        return super.nextCommand;
    }
}
}