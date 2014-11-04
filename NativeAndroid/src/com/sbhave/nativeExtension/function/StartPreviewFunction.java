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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/com/sbhave/nativeExtension/function/StartFunction.java
 */

package com.sbhave.nativeExtension.function;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;

public class StartPreviewFunction implements FREFunction {

	@Override
	public FREObject call(final FREContext ctx, FREObject[] args) {
        Log.i("QRStartFunction", "call");
        FREObject retVal = null;
        Activity rootActivity = ctx.getActivity();
        String requiredCam=null;
        int x,y,w,h;
        try {
            if(args.length == 5){
                requiredCam = args[0].getAsString();
                x = args[1].getAsInt();
                y = args[2].getAsInt();
                w = args[3].getAsInt();
                h = args[4].getAsInt();
                QRExtensionContext thisContext = ((QRExtensionContext) ctx);
                int camId = thisContext.getCameraId(requiredCam);
                Log.i("QRStartFunction", "Adding preview to stage");
                boolean previewStarted = thisContext.getPreviewManager().startPreview(camId,x,y,w,h);
                retVal = FREObject.newObject(previewStarted);
            }
		} catch (Exception e) {
            Log.e("FRE", "Error in " + this.getClass().getSimpleName(), e);
            retVal = null;
		}

		return retVal;
	}
}
