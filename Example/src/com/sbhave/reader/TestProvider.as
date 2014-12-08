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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/Example/src/com/sbhave/reader/TestProvider.as
 */

package com.sbhave.reader {
import com.sbhave.reader.tests.MultiScanSimple;
import com.sbhave.reader.tests.PreviewOrientation;
import com.sbhave.reader.tests.ScanBitmapTest;
import com.sbhave.reader.tests.SingleScanSimple;
import com.sbhave.reader.tests.SizeAndPosition;

public class TestProvider {

    private const _testsPackage:String = "com.sbhave.reader.tests"
    private var testsToRun:Vector.<TestCase> = new Vector.<TestCase>();

    public function TestProvider(tests:Vector.<String>=null) {
        /** Wont work because of Dead Code Elimination
         * var testNames:Vector.<String> = null;
         if(tests == null){
            var allClasses:Vector.<String> = ApplicationDomain.currentDomain.getQualifiedDefinitionNames();
            for each (var cls:String in allClasses){
               if (cls.indexOf(_testsPackage) != -1){
                   trace(cls);
               }
            }
        }else{
            testNames= tests;
        }
         */
        testsToRun.push(new SingleScanSimple());
        testsToRun.push(new MultiScanSimple());
        testsToRun.push(new PreviewOrientation());
        testsToRun.push(new SizeAndPosition());
        testsToRun.push(new ScanBitmapTest());



    }

    public function getNextTest():TestCase{
        return testsToRun.pop();
    }
}
}
