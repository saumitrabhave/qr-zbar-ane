package com.sbhave.nativeExtension.function;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;

public class SetConfigFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] args) {
		
		if (args == null || args.length < 3)
			return null;
		
		try {
			
			QRExtensionContext.getInstance().getScanner().setConfig(args[0].getAsInt(),args[1].getAsInt(),args[2].getAsInt());
			
		} catch (Exception e) {
			Log.e("QRSetConfig", "Error: " + e.getMessage() + " : " + e.getClass().getCanonicalName()); 
		} 
		
		return null;
	}

}
