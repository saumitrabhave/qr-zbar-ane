package com.sbhave.nativeExtension;

import java.util.HashMap;
import java.util.Map;

import net.sourceforge.zbar.Config;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;

import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.sbhave.nativeExtension.function.GetLaunchStatusFunction;
import com.sbhave.nativeExtension.function.ResetFunction;
import com.sbhave.nativeExtension.function.SetConfigFunction;
import com.sbhave.nativeExtension.function.SetTargetAreaFunction;
import com.sbhave.nativeExtension.function.StartFunction;
import com.sbhave.nativeExtension.function.StopFunction;


public class QRExtensionContext extends FREContext {

	// ZBar Objects
	ImageScanner scanner;

	private boolean barcodeScanned = false;
	private boolean previewing = true;
	private boolean launched = false;
	private boolean singleScan = false;
	
	private int targetSize = 100;
	private int targetColor = 0xFFFF0000;
	private int targetSuccessColor = 0xFF00FF00;

	public static final String FRE_EXTENSION_CONTEXT = "com.sbhave.nativeExtension.freContext"; 

	private static final QRExtensionContext INSTANCE = new QRExtensionContext();

	private QRExtensionContext(){
		this.resetScanner();
	}

	public static QRExtensionContext getInstance()
	{
		return INSTANCE;
	}

	@Override
	public void dispose() {
		scanner.destroy();
		scanner = null;
		Log.i("QRExtensionContext", "dispose()");
	}

	@Override
	public Map<String, FREFunction> getFunctions() {

		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

		functionMap.put("start", new StartFunction() );
		functionMap.put("stop", new StopFunction() );
		functionMap.put("setConfig", new SetConfigFunction() );
		functionMap.put("targetArea", new SetTargetAreaFunction() );
		functionMap.put("reset", new ResetFunction() );
		functionMap.put("launchStatus", new GetLaunchStatusFunction() );

		return functionMap;
	}

	public void resetScanner() {
		Log.i("QRExtensionContext", "Reset Scanner");
		ImageScanner is = new ImageScanner();

		is.setConfig(0, Config.X_DENSITY, 1);
		is.setConfig(0, Config.Y_DENSITY, 1);
		is.setConfig(0, Config.ENABLE, 0);
		is.setConfig(Symbol.QRCODE, Config.ENABLE, 1);

		scanner = is;
	}

	public ImageScanner getScanner()
	{
		return scanner;
	}

	public int getTargetSize() {
		return targetSize;
	}

	public void setTargetSize(int targetSize) {
		this.targetSize = targetSize;
	}

	public int getTargetColor() {
		return targetColor;
	}

	public void setTargetColor(int targetColor) {
		this.targetColor = targetColor;
	}

	public int getTargetSuccessColor() {
		return targetSuccessColor;
	}

	public void setTargetSuccessColor(int targetSuccessColor) {
		this.targetSuccessColor = targetSuccessColor;
	}

	public boolean isBarcodeScanned() {
		return barcodeScanned;
	}

	public void setBarcodeScanned(boolean barcodeScanned) {
		this.barcodeScanned = barcodeScanned;
	}

	public boolean isPreviewing() {
		return previewing;
	}

	public void setPreviewing(boolean previewing) {
		this.previewing = previewing;
	}

	public boolean isLaunched() {
		return launched;
	}

	public void setLaunched(boolean launched) {
		this.launched = launched;
	}

	public boolean isSingleScan() {
		return singleScan;
	}

	public void setSingleScan(boolean singleScan) {
		this.singleScan = singleScan;
	}
}
