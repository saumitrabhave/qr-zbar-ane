////////////////////////////////////////////////////////////////////////////////////////////////////////	
//	ADOBE SYSTEMS INCORPORATED																		  //
//	Copyright 2011 Adobe Systems Incorporated														  //
//	All Rights Reserved.																			  //
//																									  //
//	NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the		  //
//	terms of the Adobe license agreement accompanying it.  If you have received this file from a	  //
//	source other than Adobe, then your use, modification, or distribution of it requires the prior	  //
//	written permission of Adobe.																	  //
////////////////////////////////////////////////////////////////////////////////////////////////////////

package com.sbhave.nativeExtension.function;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;

public class StopFunction implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {

		FREObject retVal = null;
		QRExtensionContext extCtx = (QRExtensionContext)ctx;	
		
		try {
			
			if(extCtx.isLaunched()){
				Log.e("QRStopFunction", "Stopping Scanner");
				extCtx.getActivity().finishActivity(100);
				retVal = FREObject.newObject(true);
			}else{
				retVal = FREObject.newObject(true);
				Log.e("QRStopFunction", "Scanner is not running");
			}
		} catch (Exception e) {
			Log.e("QRStopFunction", e.getMessage());
			return null;
		}

		return retVal;
	}

}
