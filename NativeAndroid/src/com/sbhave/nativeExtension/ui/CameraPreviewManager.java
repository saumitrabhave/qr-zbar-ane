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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/com/sbhave/nativeExtension/ui/CameraPrivewManager.java
 */

package com.sbhave.nativeExtension.ui;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.hardware.Camera;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import com.sbhave.nativeExtension.QRExtensionContext;
import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;

import java.util.List;

public class CameraPreviewManager {

    private Activity mActivity = null;
    private QRExtensionContext mContext = null;
    private ImageScanner mScanner = null;
    private final Camera.PreviewCallback previewCb = new Camera.PreviewCallback() {
        public void onPreviewFrame(byte[] data, Camera camera) {
            if(mScanner != null) {
                QRExtensionContext freContext = mContext;
                Camera.Parameters parameters = camera.getParameters();
                Camera.Size size = parameters.getPreviewSize();
                Image barcode = new Image(size.width, size.height, "Y800");
                barcode.setData(data);
                int result = mScanner.scanImage(barcode);

                if (result != 0) {
                    SymbolSet syms = mScanner.getResults();
                    for (Symbol sym : syms) {
                        freContext.setBarcodeScanned(true);
                        freContext.dispatchStatusEventAsync("data", sym.getData());
                    }
                }
            }
        }
    };
    private Camera mCamera = null;
    private CameraPreview mPreview = null;
    private boolean isPreviewOn=false;
    private boolean isScanning=false;
    private Handler autoFocusHandler= new Handler();
    private int mCameraId = -1;
    private int _x=0,_y=0,_w=-1,_h=-1;

    public CameraPreviewManager(Activity activity,QRExtensionContext ctx) {
        mActivity = activity;
        mContext = ctx;
    }

    public boolean startPreview(int cameraId){
        return startPreview(cameraId,_x,_y,_w,_h);
    }

    public void stopPreview(){
        isPreviewOn = false;
        isScanning = false;
        removePreviewFromStage();
        mPreview = null;
        releaseCamera();
    }

    public void startScanning(ImageScanner scanner) throws Exception {
        if(isPreviewOn && !isScanning){
            mScanner = scanner;
            isScanning = true;
        }else{
            throw new Exception("Scanner already attached or preview not on stage yet.");
        }
    }

    public void stopScanning() throws Exception {
        if(isScanning){
            mScanner = null;
            isScanning = false;
        }else{
            throw new Exception("Scanner already attached or preview not on stage yet.");
        }
    }

    private void removePreviewFromStage() {
        if(mPreview != null){
            ViewGroup rootView = (ViewGroup)mActivity.getWindow().getDecorView().findViewById(android.R.id.content);
            rootView.removeView(mPreview);
        }
    }

    public void pausePreview(){
        if(isPreviewOn && mCamera != null){
            releaseCamera();
        }
    }

    public void resumePreview(){
        if(isPreviewOn && mCamera != null){
            Camera c = getCameraInstance(mCameraId);
            mPreview.restartPreview(c);
        }
    }

    public boolean startPreview(int cameraId,int x,int y,int w, int h){
        if(mCamera == null){
            mCameraId = cameraId;
            mCamera = getCameraInstance(mCameraId);
            Camera.Parameters ps = mCamera.getParameters();
            Log.e("sbhave", "Preview Sizes");
            for(Camera.Size s : ps.getSupportedPreviewSizes()){
                Log.e("sbhave", "Width: " + s.width + " Height: " + s.height);
            }
            mPreview = new CameraPreview(mActivity, mCamera, previewCb, autoFocusCB);
            setPosition(x,y);
            setLayout(w,h);
            addPreviewToStage();
            isPreviewOn = true;
            return true;
        }else{
            return false;
        }

    }

    @SuppressLint("NewApi")
    public void setPosition(int x, int y){
        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB ){
            _x = x;
            _y = y;
            if(mPreview != null){
                mPreview.setTranslationX(x);
                mPreview.setTranslationY(y);

            }
        }
    }

    public void setLayout(int w, int h){
        if (w == -1) w = FrameLayout.LayoutParams.MATCH_PARENT;
        if (h == -1) h = FrameLayout.LayoutParams.MATCH_PARENT;

        _w = w;
        _h = h;

        if(mPreview != null){
            FrameLayout.LayoutParams previewParams = new FrameLayout.LayoutParams(
                    w,
                    h, Gravity.NO_GRAVITY);
            mPreview.setLayoutParams(previewParams);
        }
    }

    private void addPreviewToStage() {
        if(mPreview != null){
            mPreview.setZOrderOnTop(true);
            ViewGroup rootView = (ViewGroup)mActivity.getWindow().getDecorView().findViewById(android.R.id.content);
            rootView.addView(mPreview);
        }
    }

    private Camera getCameraInstance(int cameraID){
        Camera c = null;
        try {
            if (cameraID != -1)
                c = Camera.open(cameraID);
            else
                c = Camera.open();
        } catch (Exception e){
            Log.e("FRE","Exception while acquiring Camera",e);
        }
        return c;
    }

    public List<Camera.Size> getPreviewSizes(){
        if(mCamera != null){
            return mCamera.getParameters().getSupportedPreviewSizes();
        }
        return null;
    }

    private void releaseCamera() {
        if (mCamera != null) {

            mCamera.setPreviewCallback(null);
            mCamera.release();
            mCamera = null;
        }
    }

    // Mimic continuous auto-focusing
    private final Camera.AutoFocusCallback autoFocusCB = new Camera.AutoFocusCallback() {
        public void onAutoFocus(boolean success, Camera camera) {
            autoFocusHandler.postDelayed(doAutoFocus, 1000);
        }
    };

    private final Runnable doAutoFocus = new Runnable() {
        public void run() {
            if (isPreviewOn)
                mCamera.autoFocus(autoFocusCB);
        }
    };

    public void destroy() {
        mScanner = null;
        if(isPreviewOn){
            removePreviewFromStage();
            mPreview = null;
            releaseCamera();
        }
    }

    public void setOrientation(int orientation) {
        if(mCamera != null){
            if (android.os.Build.VERSION.SDK_INT <= Build.VERSION_CODES.HONEYCOMB_MR2 ){
                mCamera.stopPreview();
                mCamera.setDisplayOrientation(orientation);
                mCamera.startPreview();
            }
            mCamera.setDisplayOrientation(orientation);
        }
    }

    public void setPreviewSize(int w, int h) {
        if(mCamera != null){
            Camera.Parameters params = mCamera.getParameters();
            if(params.getPreviewSize().width != w || params.getPreviewSize().height != h){
                mCamera.stopPreview();
                params.setPreviewSize(w,h);
                mCamera.setParameters(params);
                mCamera.startPreview();
            }
        }
    }
}
