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

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sbhave.nativeExtension.QRExtensionContext;
import com.sbhave.nativeExtension.ui.CameraActivity;

public class StartFunction implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {

		Log.i("QRStartFunction", "call");

		FREObject retVal;
		retVal = null;

		try {
			
			QRExtensionContext.getInstance().setSingleScan(args[0].getAsBool());
			Log.i("QRStartFunction", "Is already lanched? " +  QRExtensionContext.getInstance().isLaunched());
			
			if(!QRExtensionContext.getInstance().isLaunched())
			{
				Log.i("QRStartFunction", "Creating intent for activity");
				Intent intent = new Intent(QRExtensionContext.getInstance().getActivity(), CameraActivity.class);
                Bundle data = new Bundle();
                data.putString("camera",args[1].getAsString());
                intent.putExtras(data);

				Log.i("QRStartFunction", "Launching activity");
				QRExtensionContext.getInstance().getActivity().startActivityForResult(intent,100);
				QRExtensionContext.getInstance().setLaunched(true);
				retVal = FREObject.newObject(true);
			}else{
				
				retVal = FREObject.newObject(false);
			}
		} catch (Exception e) {
			Log.e("QRStartFunction", e.getMessage());
			return null;
		}

		return retVal;
	}
}
