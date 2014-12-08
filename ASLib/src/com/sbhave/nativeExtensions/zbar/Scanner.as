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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/ASLib/src/com/sbhave/nativeExtensions/zbar/Scanner.as
 */

package com.sbhave.nativeExtensions.zbar
{
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

/**
 * A Facade to Barcode scanning functionality, Basically it provides two high level
 * ways of scanning a Barcode.
 * 1. Application takes the responsibility of generating, fetching, receiving Images to be
 *      scanned for barcode. Provide this as a BitmapData to Scanner for running ZBar scanning
 *      on the given object. Inspired by {@see https://github.com/luarpro/BitmapDataQRCodeScanner}
 * 2. Use the Devices hardware Camera to show a preview to the user via configure position and Dimension
 *      of a preview element. Note that, you can render your own UI AROUND the preview, but NOT over it.
 */
public class Scanner extends EventDispatcher {

    private static var extCtx:ExtensionContext = null;

    private static var isInstantiated:Boolean = false;

    /**
     * Creates a new Scanner instance which provides facade to Barcode Scanning functionality.
     * Note that that even though Scanner can be instantiated multiple times, multiple scanners
     * cannot co-exist in application. dispose must be called on earlier scanner before a
     * new one can be created again
     */
    public function Scanner(){

        if (!isInstantiated){
            extCtx = ExtensionContext.createExtensionContext("com.sbhave.nativeExtensions.zbar", null);

            if (extCtx != null){

                extCtx.addEventListener(StatusEvent.STATUS, onStatus);

            }else{
                throw new Error("Extension not supported, Please check isSupported() Before using the library");
            }

            isInstantiated = true;
        }else{
            throw new Error("One Scanner instance is alive already, please call dispose() when Scanner use is complete");
        }
    }

    /**
     * Use this static method to determine whether the device
     * has ability to do barcode scanning. It will return true on
     * All devices because Bitmap Based scanning is supported everywhere.
     * To use the Live Camera based scanning use {@see Camera} API to determine if the device
     * you are running on has hardware camera.
     * Its good practice to use this function in application right from beginning, so that
     * implementing it in future wont require application code changes.
     * @return Boolean indicating if the Scanner Can be used on the current device
     */
    public static function get isSupported():Boolean {
        if(CONFIG::simulator)
            return false;
        return true;
    }

    /**
     * This function is used to set different calibration and configuration parameters
     * for the Zbar Scanner. Please use Constants defined in Config and Symbology Class
     * as values for first two parameters. for reference on values to be set or meaning of parameters
     * {@see http://zbar.sourceforge.net/iphone/sdkdoc/ZBarImageScanner.html#constants}
     * @param symbology Symbology as defined in {@see Symbology} for which you want
     *          to set the configuration.
     * @param config Configuration Key as defined in {@see Config}, this config will be set for
     *          the Symbology, provided in first parameter
     * @param value An integer value for the given configuration Key.
     */
    public function setConfig(symbology:int,config:int,value:int):void{
        extCtx.call("setConfig",symbology,config,value);
    }

    /**
     * Call this when application is done with Scanner usage. Note that this method will free-up
     * all the resources held and acquiring those again can be a heavy process. Hence, call this
     * method only when you know that Scanner will not be needed at all or when you are suspending etc.
     * In case your application allows to do scanning again and again DONT call this method after each scan.
     */
    public function dispose():void {
        extCtx.dispose();
        extCtx = null;
        isInstantiated = false;
    }

    /**
     * If you have calibrated the scanner using setConfig(). Calling this method will put the
     * Scanner to default settings
     */
    public function resetConfig():void{
        extCtx.call("reset");
    }

    /**
     * Add the Hardware camera preview on to the stage, which can be used for Barcode Scanning
     * using the call to attachScannerToPreview
     * @param cameraLocation String specifying whether the "front" camera is to be used.Note that
     *          In case of multiple Front or Back camera, The first one will be picked as per
     *          OS ordering.
     * @param x X Position of the preview on Stage
     *              (Works only on HONEYCOMB or later, ignored in older versions)
     *              Defaults to 0
     * @param y Y Position of the preview on Stage
     *              (Works only on HONEYCOMB or later, ignored in older versions)
     *              Defaults to 0
     * @param w Width of the Preview Area
     *              Defaults to Stage Width
     * @param h Height of the Preview Area
     *              Defaults to Stage Height
     * @return  True if preview was started successfully,
     *              False if preview is already on stage or if error occurs
     */
    public function startPreview(cameraLocation:String="back",x:int=0,y:int=0,w:int=-1,h:int=-1):Boolean{
        var ret:Object = extCtx.call("startPreview",cameraLocation,x,y,w,h);

        if(ret==null)
            return false;
        else
            return ret as Boolean;
    }

    /**
     * Sets the X,Y Position of the preview, if it is in progress, NOOP otherwise.
     *      This method works only on HONEYCOMB or later, ignored in older versions
     * @param x X Position of the preview on Stage
     *              Defaults to 0
     * @param y Y Position of the preview on Stage
     *              Defaults to 0
     */
    public function setPosition(x:int=0,y:int=0):void{
        extCtx.call("setPosition",x,y);
    }

    /**
     * Set Dimensions of the preview area if the preview is in progress,NOOP otherwise
     * @param w Width of the Preview Area as per screen device pixels
     * @param h Height of the Preview Area as per screen device pixels
     */
    public function setDimensions(w:int=-1,h:int=-1):void{
        extCtx.call("setDimension",w,h);
    }

    /**
     * Pause the preview so that Camera feed is not updated and its freed for use by other apps
     * Its intended use-cases include, on DEACTIVATE event when your app will go in background.
     * To simulate single scanning mode, where preview will be paused as soon as Barcode is detected.
     * NOOP if preview is not in progress
     */
    public function pausePreview():void{
        extCtx.call("pausePreview");
    }

    /**
     * Logically negate the pause preview method
     * NOOP if preview is not in progress
     */
    public function resumePreview():void{
        extCtx.call("resumePreview");
    }

    /**
     * Logically Negate the startPreview method, this will remove the preview feed from stages.
     * NOOP if preview is not in progress
     */
    public function stopPreview():void{
        extCtx.call("stopPreview");
    }

    /**
     * Queries Camera for its supported preview sizes. one of these can be set using the
     *      setPreviewSize method. This Method can be called only when Preview is in progress
     *      as this requires Camera to be acquired.
     * @param camera String specifying Camera to be queries for supported sizes. "front" for front
     *          anything else for Back
     * @return Vector of Size Objects specifying the Preview Sizes Supported
     */
    public function getAvailablePreviewSizes():Vector.<Size>{
       var resp:Object = extCtx.call("getPreviewSizes");
       if(resp != null){
            var strResp:String = resp as String;
            var respVector:Vector.<Size> = new Vector.<Size>();
            var arrSizes:Array = strResp.split(":")
            for each (var sizeStr:String in arrSizes){
                var wh:Array = sizeStr.split(",");
                var size:Size = new Size(new Number(wh[0]),new Number(wh[1]));
                respVector.push(size);
            }
            return respVector;
       }else{
           return null;
       }
    }

    /**
     * Sets the preview size when using the Camera feed. It is recommended to use this method
     *      to set the camera preview size as per the preview view's dimensions. Lower
     *      the preview size faster is the Barcode Recognition.
     * Call to this method is Sticky, the preview size is stored internally and used whenever
     *      preview starts or changes immediately if preview is in progress already.
     * While Setting the Size, application needs to take care that its setting the supported size
     *      For eg. if supportedSizes were queried for Rear Camera and set for the preview which is using
     *      Front Camera, Code may fail if the Preview Size is not supported for Front Camera.
     * @param size Preview Size to be used.
     */
    public function setPreviewSize(size:Size):void{
        extCtx.call("setPreviewSize",size.width,size.height);
    }

    /**
     * Queries Camera for its Orientation. Note that Screen Orientation and Camera Orientation
     *      May Not be same. Because Camera is Mounted on hardware in Landscape Mode most of the times.
     *      Hence, Your Rear Camera Orientation will be 90 degrees when device is held in portrait
     * @param camera String specifying Camera to be queried for orientations. "front" for front
     *          anything else for Back
     * @return int defining the degrees of rotation. -1 if unknown error occurs
     */
    public function getCameraOrientation(camera:String="rear"):int{
        var resp:Object = extCtx.call("getOrientation",camera);
        if(resp != null){
            return resp as int;
        }

        return -1;
    }

    /**
     * Sets the orientation of Camera when using the Camera feed. See the Examples on How to use this
     *      to support natural looking preview in all orientations.
     * Call to this method is Sticky, the orientation is stored internally and used whenever
     *      preview starts or changes immediately if preview is in progress already.
     * While Setting the Orientation, application needs to take care that its setting the supported orientation
     *      For eg. if orientation were queried for Rear Camera and set for the preview which is using
     *      Front Camera, Code may fail or show incorrect rotations if the Orientation differs.
     * Must be called when preview is in progress and is not paused.
     * @param orientation Preview Size to be used.
     */
    public function setCameraOrientation(orientation:int):void{
        extCtx.call("setOrientation",orientation);
    }

    /**
     * Starts scanning the Camera Preview for any Barcode as per the Config in setConfig()
     * @throws Error if preview is not in progress
     */
    public function attachScannerToPreview():void{
        var resp:Object = extCtx.call("attachScanner");
        if(resp == null){
            throw new Error("Preview Not in Progress");
        }
    }

    /**
     * Stops scanning the Camera Preview for any Barcode.
     * @throws Error if preview is not in progress
     */
    public function detachScannerFromPreview():void{
        var resp:Object = extCtx.call("detachScanner");
        if(resp == null){
            throw new Error("Preview or Scanning Not in Progress");
        }
    }

    /**
     *
     * @param bitmap Bitmap to be scanned for Barcode as per the Config done in setConfig
     * @return Vector of String representing the Barcode detected. null otherwise
     */
    public function scanBitmapData(bitmap:BitmapData):Array{
        var resp:Object = extCtx.call("scanBitmap",bitmap);
        if(resp == null){
            return null;
        }
        return resp as Array;
    }

    /**
     * Internal Event recieved from Native Code. The Data received from Native Code is
     * parsed here and relayed as a ScannerEvent to the application.
     * @param e EventObject Containing data from Native Code.
     */
    private function onStatus(e:StatusEvent):void {

        trace("Received Event: " + e.code)
        switch(e.code)	{
            case "data":
                dispatchEvent(new ScannerEvent(ScannerEvent.SCAN,e.level));
                break;
            case "previewTouched":
                dispatchEvent(new ScannerEvent(ScannerEvent.PREVIEW_TOUCH,e.level));
                break;
        }
    }
}
}