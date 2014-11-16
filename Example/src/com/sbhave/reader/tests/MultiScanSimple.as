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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/tests/MultiScanSimple.as
 */
package com.sbhave.reader.tests {
import com.sbhave.nativeExtensions.zbar.Config;
import com.sbhave.nativeExtensions.zbar.Scanner;
import com.sbhave.nativeExtensions.zbar.ScannerEvent;
import com.sbhave.nativeExtensions.zbar.Symbology;
import com.sbhave.reader.Command;
import com.sbhave.reader.Logger;
import com.sbhave.reader.TestCase;
import com.sbhave.reader.commands.ButtonCommand;
import com.sbhave.reader.commands.QuestionCommand;

public class MultiScanSimple extends TestCase{

    private var s:Scanner;
    private var ctr:int = 0;

    public function MultiScanSimple() {
        super("BVT Multi Scan","Verify that Multi Scan Works");
    }

    override protected function initialize():void{
        // 1. Create a new Scanner() object. Whnever your design allows have only one instance of this
        s = new Scanner();
    }

    override protected function  destroy():void{
        s.dispose();
        s = null;
    }

    override protected function getCommand():Command{
        var qc = new QuestionCommand("Do you see scanned codes in Log?",this);
        var bc:ButtonCommand = new ButtonCommand("Click",launchMultiScan,"Scan Multiple QR Codes and Press Bk",qc);
        return bc;
    }

    private function launchMultiScan():void {
        trace("starting");
        s.resetConfig();  // Only QR Code By default
        s.addEventListener(ScannerEvent.SCAN,onScan);
        s.startPreview("rear"); // Multiple scans, until user presses back button to come back to the app.
        s.attachScannerToPreview();
    }

    private function onScan(event:ScannerEvent):void {
        if(ctr < 5) {
            Logger.printLine("Scan Event " + event.data);
            ctr++;
        }else{
            s.stopPreview();
        }
    }
}
}
