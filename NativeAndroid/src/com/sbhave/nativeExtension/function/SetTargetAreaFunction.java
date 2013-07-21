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
			
			QRExtensionContext.getInstance().setTargetSize(args[0].getAsInt());
			QRExtensionContext.getInstance().setTargetColor(Color.parseColor("#" + color1));
			QRExtensionContext.getInstance().setTargetSuccessColor(Color.parseColor("#" + color2));
			
			
		} catch (Exception e) {
			Log.e("QRSetTargetAre", "Error: " + e.getMessage() + " : " + e.getClass().getCanonicalName()); 
		} 
		
		return null;
	}

}
