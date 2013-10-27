/*
 * Basic no frills app which integrates the ZBar barcode scanner with
 * the camera.
 * 
 * Created by lisah0 on 2012-02-24
 */
package com.sbhave.nativeExtension.ui;

import android.content.pm.PackageManager;
import com.sbhave.nativeExtension.QRExtensionContext;

import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.PixelFormat;
import android.hardware.Camera;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.Size;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

public class CameraActivity extends Activity
{
	QRExtensionContext freContext;
	private Camera mCamera;
	private CameraPreview mPreview;
	private Handler autoFocusHandler;
	private DrawView dv;
    private int camId;

	TextView scanText;
	Button scanButton;
	FrameLayout preview;

	ImageScanner scanner;

	static {
		System.loadLibrary("iconv");
	} 

	public void onCreate(Bundle savedInstanceState) {
		Log.e("sbhave", "4");
		super.onCreate(savedInstanceState);
		freContext = QRExtensionContext.getInstance();
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		Log.e("sbhave", "5");

        PackageManager pm = getPackageManager();
        boolean frontCam, rearCam;
        camId = -1;
        //Must have a targetSdk >= 9 defined in the AndroidManifest
        frontCam = pm.hasSystemFeature("android.hardware.camera.front");
        String requiredCam = getIntent().getExtras().getString("camera");

        if (frontCam && requiredCam!= null && requiredCam.equalsIgnoreCase("front")){
            int numberOfCameras = Camera.getNumberOfCameras();

            // Find the ID of the default camera
            Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
            for (int i = 0; i < numberOfCameras; i++) {
                Camera.getCameraInfo(i, cameraInfo);
                if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
                    camId = i;
                }
            }
        }

		setContentView(freContext.getResourceId("layout.campreview"));//R.layout.campreview); 

		Log.e("sbhave", "6");
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

		Log.e("sbhave", "7");
		autoFocusHandler = new Handler();
		mCamera = getCameraInstance(camId);
		Log.e("sbhave", "8");

		scanner = freContext.getScanner();

		mPreview = new CameraPreview(this, mCamera, previewCb, autoFocusCB);
		preview = (FrameLayout)findViewById(freContext.getResourceId("id.cameraPreview"));

		freContext.setPreviewing(true);
        freContext.setBarcodeScanned(false);
		
		
		preview.addView(mPreview);
		dv = new DrawView(this,freContext);
		preview.addView(dv);
		dv.setZOrderOnTop(true);    // necessary
		SurfaceHolder h = dv.getHolder();
		h.setFormat(PixelFormat.TRANSPARENT);

		scanText = (TextView)findViewById(freContext.getResourceId("id.scanText"));

		scanButton = (Button)findViewById(freContext.getResourceId("id.ScanButton"));
		scanButton.setVisibility(View.INVISIBLE);

		scanButton.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (freContext.isBarcodeScanned()) {
					freContext.setBarcodeScanned(false);
					scanText.setText("Place the code inside target area");
					mCamera.setPreviewCallback(previewCb);
					mCamera.startPreview();
					freContext.setPreviewing(true);
					mCamera.autoFocus(autoFocusCB);
					scanButton.setVisibility(View.INVISIBLE);
					dv.setTargetColor(QRExtensionContext.getInstance().getTargetColor());
					dv.invalidate();
				}
			}
		});
	}

	public void onResume(){
		super.onResume();
		Log.i("QRActivity", "onResume Called");
		if(mCamera == null)
		{
			mCamera = getCameraInstance(camId);
			freContext.setPreviewing(true);
			mPreview.restartPreview(mCamera);
		}
	}

	public void onPause() {
		super.onPause();
		Log.i("QRActivity", "onPause Called");
		releaseCamera();
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{
	    if ((keyCode == KeyEvent.KEYCODE_BACK) || (keyCode == KeyEvent.KEYCODE_HOME))
	    {
	    	freContext.setLaunched(false);
	        finish();
	    }
	    return super.onKeyDown(keyCode, event);
	}
	
	/*@Override
    protected void onDestroy() {
        super.onDestroy();
        Log.i("QRActivity", "onDestoy Called");
        releaseCamera();
        freContext.setPreviewing(false);
        freContext.setBarcodeScanned(false);
    }*/

	/** A safe way to get an instance of the Camera object. */
	public static Camera getCameraInstance(int cameraID){
		Camera c = null;

		try {
            if (cameraID != -1)
                c = Camera.open(cameraID);
            else
                c = Camera.open();
		} catch (Exception e){
		}
		return c;
	}

	private void releaseCamera() {
		if (mCamera != null) {
			freContext.setPreviewing(false);
			mCamera.setPreviewCallback(null);
			mCamera.release();
			mCamera = null;
		}
	}

	private Runnable doAutoFocus = new Runnable() {
		public void run() {
			if (freContext.isPreviewing())
				mCamera.autoFocus(autoFocusCB);
		}
	};

	PreviewCallback previewCb = new PreviewCallback() {
		public void onPreviewFrame(byte[] data, Camera camera) {
			Camera.Parameters parameters = camera.getParameters();
			Size size = parameters.getPreviewSize();

			Image barcode = new Image(size.width, size.height, "Y800");
			barcode.setData(data);
			barcode.setCrop(0, 0, size.width, size.height);
			int result = scanner.scanImage(barcode);

			if (result != 0) {
				

				SymbolSet syms = scanner.getResults();
				for (Symbol sym : syms) {
					scanText.setText("" + sym.getData());
					freContext.setBarcodeScanned(true);
					dv.setTargetColor(QRExtensionContext.getInstance().getTargetSuccessColor());
					dv.invalidate();
					freContext.dispatchStatusEventAsync("data", sym.getData());
				}
				
				if(!freContext.isSingleScan())
				{
					freContext.setPreviewing(false);
					mCamera.setPreviewCallback(null);
					mCamera.stopPreview();
					scanButton.setVisibility(View.VISIBLE);
				}else{
					releaseCamera();
					freContext.setLaunched(false);
					CameraActivity.this.finish();
				}
			}
		}
	};

	// Mimic continuous auto-focusing
	AutoFocusCallback autoFocusCB = new AutoFocusCallback() {
		public void onAutoFocus(boolean success, Camera camera) {
			autoFocusHandler.postDelayed(doAutoFocus, 1000);
		}
	};
}
