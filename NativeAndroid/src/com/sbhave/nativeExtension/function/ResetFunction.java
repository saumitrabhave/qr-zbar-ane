package com.sbhave.nativeExtension.function;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;

public class ResetFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {

		try {

			QRExtensionContext.getInstance().resetScanner();

		} catch (Exception e) {
			Log.e("QRSetConfig", "Error: " + e.getMessage() + " : " + e.getClass().getCanonicalName()); 
		} 

		return null;
	}

}
