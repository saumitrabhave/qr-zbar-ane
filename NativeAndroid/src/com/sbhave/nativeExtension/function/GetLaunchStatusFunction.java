package com.sbhave.nativeExtension.function;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;

public class GetLaunchStatusFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		try {

			FREObject ret = FREObject.newObject(QRExtensionContext.getInstance().isLaunched());
			return ret;

		} catch (Exception e) {
			Log.e("QRGetLaunch Status", "Error: " + e.getMessage() + " : " + e.getClass().getCanonicalName()); 
		} 

		return null;
	}

}
