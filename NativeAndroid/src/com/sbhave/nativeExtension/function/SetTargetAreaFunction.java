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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/com/sbhave/nativeExtension/function/SetTargetAreaFunction.java
 */

package com.sbhave.nativeExtension.function;

import android.graphics.Color;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.sbhave.nativeExtension.QRExtensionContext;

public class SetTargetAreaFunction implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		
		Log.i("QRSetTargetArea", "call"); 
		if (args == null || args.length < 3){
			Log.i("QRSetTargetArea", "invalid arguments"); 
			return null;
		}
			
		
		try {
			String color1 = args[1].getAsString();
			String color2 = args[2].getAsString();
			 
			color1 = color1.substring(2);
			color2 = color2.substring(2);
			
            ((QRExtensionContext)ctx).setTargetSize(args[0].getAsInt());
            ((QRExtensionContext)ctx).setTargetColor(Color.parseColor("#" + color1));
            ((QRExtensionContext)ctx).setTargetSuccessColor(Color.parseColor("#" + color2));
			
			
		} catch (Exception e) {
			Log.e("QRSetTargetAre", "Error: " + e.getMessage() + " : " + e.getClass().getCanonicalName()); 
		} 
		
		return null;
	}

}
