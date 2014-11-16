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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/tests/SingleScanSimple.as
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

public class SingleScanSimple extends TestCase{

    private var s:Scanner;
    private var ctr:int=0;

    public function SingleScanSimple() {
        super("BVT Single Scan","Verify that Single Scan Works");
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
        var qc = new QuestionCommand("Do you see scanned barcode in Log?",this);
        var bc:ButtonCommand = new ButtonCommand("Click",launchSingleScan,"and Scan a BarCode",qc);
        return bc;
    }

    private function launchSingleScan():void {
        trace("starting");

        // 3. Set configs, for eg enable more symbologies, set crop area, or min-max lengths for scanned data
        s.setConfig(Symbology.EAN13,Config.ENABLE,1);

        //4. Add event listenser so that we get notfied whenever a barcode is scanned.
        s.addEventListener(ScannerEvent.SCAN,onScan);

        //5. Actually launch the scanning UI, true means UI will automatically close after 1 scan.
        s.startPreview("rear");
        s.attachScannerToPreview();
    }

    private function onScan(event:ScannerEvent):void {
        if(ctr < 1) {
            Logger.printLine("Scan Event " + event.data);
            ctr++;
        }else{
            s.stopPreview();
        }
    }
}
}
