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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/com/sbhave/nativeExtension/function/ScanBitmapFunction.java
 */

package com.sbhave.nativeExtension.function;

import android.graphics.Bitmap;
import android.util.Log;
import com.adobe.fre.*;
import com.sbhave.nativeExtension.QRExtensionContext;
import com.sbhave.nativeExtension.ui.CameraPreviewManager;
import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;

import java.util.Arrays;

//Implementation Inspired From: https://github.com/luarpro/BitmapDataQRCodeScanner
public class ScanBitmapFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] args) {
        FREObject retVal = null;
        retVal = null;
        QRExtensionContext qrCtx =(QRExtensionContext)freContext;

        if(args.length != 1){
            Log.e("saumitra","Error, Invalid number of arguments in scanBitmap");
        }

        try {
            FREBitmapData inputValue = (FREBitmapData)args[0];

            inputValue.acquire();

            int width = inputValue.getWidth();
            int height = inputValue.getHeight();

            int[] pixels = new int[width * height];
            Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            bmp.copyPixelsFromBuffer(inputValue.getBits());

            bmp.getPixels(pixels, 0, width, 0, 0, width, height);

            Image myImage = new Image(width, height, "RGB4");
            myImage.setData(pixels);
            myImage = myImage.convert("Y800");

            String[] results = qrCtx.getPreviewManager().scanImage(myImage,qrCtx.getScanner());
            inputValue.release();
            if (results != null && results.length > 0){
                FREArray freArray = FREArray.newArray(results.length);

                for(int ctr=0; ctr < results.length; ctr++){
                    FREObject freString = FREObject.newObject(results[ctr]);
                    freArray.setObjectAt(ctr, freString);
                }
                retVal = freArray;
            }



        } catch (Exception e) {
            Log.e("saumitra","Got Exception",e)  ;
            return null;
        }

        return retVal;
    }
}
