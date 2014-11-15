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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/com/sbhave/nativeExtension/QRExtensionContext.java
 */

package com.sbhave.nativeExtension;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.sbhave.nativeExtension.function.*;
import com.sbhave.nativeExtension.ui.CameraPreviewManager;
import net.sourceforge.zbar.Config;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;

import java.util.HashMap;
import java.util.Map;


public class QRExtensionContext extends FREContext {

    // ZBar Objects
    private ImageScanner scanner;
    private CameraPreviewManager mPreviewManager;

    private boolean barcodeScanned = false;
    //private boolean previewing = true;
    private boolean launched = false;
    private boolean singleScan = false;

    private int targetSize = 100;
    private int targetColor = 0xFFFF0000;
    private int targetSuccessColor = 0xFF00FF00;

    public static final String FRE_EXTENSION_CONTEXT = "com.sbhave.nativeExtension.freContext";

    private static final QRExtensionContext INSTANCE = new QRExtensionContext();

    public QRExtensionContext(){
    }

    public static QRExtensionContext getInstance()
    {
        return INSTANCE;
    }

    public CameraPreviewManager getPreviewManager(){
        if(mPreviewManager == null){
            mPreviewManager = new CameraPreviewManager(getActivity(),this);
        }
        return mPreviewManager;
    }

    @Override
    public void dispose() {
        mPreviewManager.destroy();
        scanner.destroy();
        scanner = null;
        mPreviewManager = null;
        Log.i("QRExtensionContext", "dispose()");
    }

    @Override
    public Map<String, FREFunction> getFunctions() {

        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        functionMap.put("startPreview", new StartPreviewFunction() );
        functionMap.put("stopPreview", new StopPreviewFunction() );
        functionMap.put("pausePreview", new PausePreviewFunction() );
        functionMap.put("resumePreview", new ResumePreviewFunction() );

        functionMap.put("setPosition", new SetPositionFunction() );
        functionMap.put("setDimension", new SetDimensionFunction() );

        functionMap.put("getPreviewSizes", new GetPreviewSizesFunction() );
        functionMap.put("setPreviewSize", new SetPreviewSizeFunction() );
        functionMap.put("getOrientation", new GetOrientationFunction() );
        functionMap.put("setOrientation", new SetOrientationFunction() );

        functionMap.put("attachScanner", new AttachScannerFunction() );
        functionMap.put("detachScanner", new DetachScannerFunction() );
        functionMap.put("scanBitmap", new ScanBitmapFunction() );

        functionMap.put("setConfig", new SetConfigFunction() );
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

    //public boolean isPreviewing() {
    //	return previewing;
    //}

    //public void setPreviewing(boolean previewing) {
    //	this.previewing = previewing;
    //}

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

    public int getCameraId(String cameraName){
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        return getCameraId(cameraName,cameraInfo);
    }

    public int getCameraId(String cameraName, Camera.CameraInfo cameraInfo){
        int numberOfCameras = Camera.getNumberOfCameras();
        int requiredFacing = Camera.CameraInfo.CAMERA_FACING_BACK;
        if(cameraName != null && cameraName.equalsIgnoreCase("front")){
            requiredFacing = Camera.CameraInfo.CAMERA_FACING_FRONT;
        }

        for (int i = 0; i < numberOfCameras; i++) {
            Camera.getCameraInfo(i, cameraInfo);
            if (cameraInfo.facing == requiredFacing) {
                Log.e("sbhave","Orientation: " + cameraInfo.orientation);
                return i;
            }
        }
        return -1;
    }
}
