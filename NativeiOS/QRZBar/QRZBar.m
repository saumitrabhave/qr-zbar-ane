//
//  QRZBar.m
//
// Copyright (c) 2014 Saumitra R Bhave
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
#import "FlashRuntimeExtensions.h"
#import "CameraPreviewManager.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FRE_PFX(name) QR_SBH_ ## name
#define SBH_FREFUNCTION(fName) FREObject FRE_PFX(fName)(FREContext ctx,void* funcData,uint32_t argc,FREObject argv[])
#define SBH_MAP_FUNCTION(arr,index,fname) arr[index].name = (const uint8_t*) #fname; \
arr[index].functionData = NULL; \
arr[index].function = &FRE_PFX(fname);

SBH_FREFUNCTION(setConfig);
SBH_FREFUNCTION(reset);
SBH_FREFUNCTION(startPreview);
SBH_FREFUNCTION(stopPreview);
SBH_FREFUNCTION(pausePreview);
SBH_FREFUNCTION(resumePreview);
SBH_FREFUNCTION(setPosition);
SBH_FREFUNCTION(setDimension);
SBH_FREFUNCTION(getPreviewSizes);
SBH_FREFUNCTION(setPreviewSize);
SBH_FREFUNCTION(getOrientation);
SBH_FREFUNCTION(setOrientation);
SBH_FREFUNCTION(attachScanner);
SBH_FREFUNCTION(detachScanner);
SBH_FREFUNCTION(scanBitmap);
SBH_FREFUNCTION(launchStatus);

// Intializers and Finalizers
void FRE_PFX(ContextInitializer)(void* , const uint8_t*, FREContext,
                               uint32_t*, const FRENamedFunction**);
void FRE_PFX(ContextFinalizer)(FREContext);
void QRSBHExtInitializer(void**,FREContextInitializer* ,
                         FREContextFinalizer*);
void QRSBHExtFinalizer(void*);


SBH_FREFUNCTION(setConfig)
{
    NSLog(@"Call setConfig");
    
    if(argc < 3)
    {
        NSLog(@"Not enough arguments");
        return nil;
    }
    
    int32_t symbology,config,val;
    
    FREGetObjectAsInt32(argv[0], &symbology);
    FREGetObjectAsInt32(argv[1], &config);
    FREGetObjectAsInt32(argv[2], &val);
    NSLog(@"SYM:%d CONFIG:%d VAL:%d",symbology,config,val);
    
    [[CameraPreviewManager sharedPreviewManager].imageScanner setSymbology:symbology config:config to:val];
    
    return nil;
}

SBH_FREFUNCTION(reset)
{
    if(![CameraPreviewManager sharedPreviewManager].scanning)
    {
        [[CameraPreviewManager sharedPreviewManager] resetScanner];
    }
    
    return NULL;
}

SBH_FREFUNCTION(startPreview)
{
    FREObject retVal = NULL;
    NSLog(@"Entering Start Preview");
    if(argc != 5) { NSLog(@"Expected 5 arguments [cameraPosition,x,y,w,h]."); return NULL;}
    
    uint32_t len;
    int32_t x,y,w,h;
    uint8_t* camPos = nil;
    NSString* camPosStr = nil;
    
    // Read ActionScript Function Parameters
    FREGetObjectAsUTF8(argv[0], &len, (const uint8_t**)&camPos);
    FREGetObjectAsInt32(argv[1], &x);
    FREGetObjectAsInt32(argv[2], &y);
    FREGetObjectAsInt32(argv[3], &w);
    FREGetObjectAsInt32(argv[4], &h);
    
    // Sanitize
    if(camPos != NULL){
        camPosStr = [NSString stringWithUTF8String:(const char*)camPos];
    }else{
        camPosStr = @"back";
    }
    
    if(w < 0) w = [[ CameraPreviewManager sharedPreviewManager].freRootView bounds].size.width;
    if(h < 0) h = [[ CameraPreviewManager sharedPreviewManager].freRootView bounds].size.height;
    
    if(![CameraPreviewManager sharedPreviewManager].previewing)
    {
        NSLog(@"Calling Preview Manager");
        [[CameraPreviewManager sharedPreviewManager] startPreviewWithCamera:camPosStr atPostion:CGRectMake(x, y, w, h)];
        FRENewObjectFromBool((uint32_t)YES, &retVal);
        
    }else{
        FRENewObjectFromBool((uint32_t)NO, &retVal);
    }
    
    return retVal;
}

SBH_FREFUNCTION(stopPreview)
{
    [[CameraPreviewManager sharedPreviewManager] stopPreview];
    return NULL;

}
SBH_FREFUNCTION(pausePreview)
{
    
    [[CameraPreviewManager sharedPreviewManager] pause];
    
    return NULL;
}

SBH_FREFUNCTION(resumePreview)
{
    
    [[CameraPreviewManager sharedPreviewManager] resume];
    
    return NULL;
}
SBH_FREFUNCTION(setPosition)
{
    if(argc != 2) { NSLog(@"Expected 1 argument [x,y]."); return NULL;}
    
    double x,y;
    
    FREGetObjectAsDouble(argv[0], &x);
    FREGetObjectAsDouble(argv[1], &y);
    
    [[CameraPreviewManager sharedPreviewManager] setX:x andY:y];
    
    return NULL;
}

SBH_FREFUNCTION(setDimension)
{
    if(argc != 2) { NSLog(@"Expected 2 argument [w,h]."); return NULL;}
    
    double w,h;
    
    FREGetObjectAsDouble(argv[0], &w);
    FREGetObjectAsDouble(argv[1], &h);
    
    [[CameraPreviewManager sharedPreviewManager] setWidth:w andHeight:h];
    
    return NULL;
}

SBH_FREFUNCTION(getPreviewSizes)
{
    NSString* retVal = nil;
    FREObject retObj;
    
    retVal = [[CameraPreviewManager sharedPreviewManager] supportedPreviewSizes];
    
    FRENewObjectFromUTF8([retVal length], (const unsigned char*)[retVal UTF8String], &retObj);
    return retObj;
}
SBH_FREFUNCTION(setPreviewSize)
{
    int w,h;
    
    if(argc != 2) { NSLog(@"Expected 2 argument [w,h]."); return NULL;}
    
    FREGetObjectAsInt32(argv[0], &w);
    FREGetObjectAsInt32(argv[1], &h);
    
    [[CameraPreviewManager sharedPreviewManager] setPreviewWidth:w andHeight:h];
    
    return NULL;
}
SBH_FREFUNCTION(getOrientation)
{
    if(argc != 1) { NSLog(@"Expected 1 argument [cameraPosition]."); return NULL;}
    
    uint8_t* camPos = nil;
    uint32_t len;
    NSString* camPosStr = nil;
    FREObject retVal;
    FREGetObjectAsUTF8(argv[0], &len, (const uint8_t**)&camPos);
    
    // Sanitize
    if(camPos != NULL){
        camPosStr = [NSString stringWithUTF8String:(const char*)camPos];
    }else{
        camPosStr = @"back";
    }
    
    if ([camPosStr isEqualToString:@"front"]) {
        FRENewObjectFromInt32(0, &retVal);
    }else{
        FRENewObjectFromInt32(0, &retVal);
    }
    
    return retVal;
}
SBH_FREFUNCTION(setOrientation)
{
    if(argc != 1) { NSLog(@"Expected 1 argument [degrees]."); return NULL;}
    UIInterfaceOrientation previewOrientation;
    int32_t degrees;
    FREGetObjectAsInt32(argv[0], &degrees);
    NSLog(@"Rotating to %d degrees",degrees);
    switch (degrees) {
        case 0:
            previewOrientation = UIInterfaceOrientationPortrait;
            break;
        case 90:
            previewOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case 180:
            previewOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        case 270:
            previewOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        default:
            previewOrientation = UIInterfaceOrientationPortrait;
            break;
    }
    
    [[CameraPreviewManager sharedPreviewManager] setOrientation:previewOrientation];
    return NULL;
}
SBH_FREFUNCTION(attachScanner)
{
    FREObject retVal = NULL;
    if ([CameraPreviewManager sharedPreviewManager].previewing) {
        [CameraPreviewManager sharedPreviewManager].scanning = YES;
        FRENewObjectFromBool(YES, &retVal);
    }
    
    return retVal;
}

SBH_FREFUNCTION(detachScanner)
{
    FREObject retVal = NULL;
    if ([CameraPreviewManager sharedPreviewManager].previewing) {
        [CameraPreviewManager sharedPreviewManager].scanning = NO;
        FRENewObjectFromBool(YES, &retVal);
    }
    
    return retVal;
}

//TODO
SBH_FREFUNCTION(scanBitmap){ return NULL;}

/*
 This has been removed from ASLib. Kept in case an use-case comes up to support this.
 */
SBH_FREFUNCTION(launchStatus){ return NULL;}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void FRE_PFX(ContextInitializer)(void* extData, const uint8_t* ctxType, FREContext ctx,
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    [CameraPreviewManager sharedPreviewManager].freContext = ctx;
    
	*numFunctionsToTest = 16;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 16);
	
    SBH_MAP_FUNCTION(func, 0, setConfig)
    SBH_MAP_FUNCTION(func, 1, reset)
    SBH_MAP_FUNCTION(func, 2, startPreview)
    SBH_MAP_FUNCTION(func, 3, stopPreview)
    SBH_MAP_FUNCTION(func, 4, launchStatus)
    SBH_MAP_FUNCTION(func, 5, pausePreview)
    SBH_MAP_FUNCTION(func, 6, setPosition)
    SBH_MAP_FUNCTION(func, 7, setDimension)
    SBH_MAP_FUNCTION(func, 8, getPreviewSizes)
    SBH_MAP_FUNCTION(func, 9, setPreviewSize)
    SBH_MAP_FUNCTION(func, 10, getOrientation)
    SBH_MAP_FUNCTION(func, 11, setOrientation)
    SBH_MAP_FUNCTION(func, 12, attachScanner)
    SBH_MAP_FUNCTION(func, 13, detachScanner)
    SBH_MAP_FUNCTION(func, 14, scanBitmap)
    SBH_MAP_FUNCTION(func, 15, resumePreview)
    
	*functionsToSet = func;
}

// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void FRE_PFX(ContextFinalizer)(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    
    [[CameraPreviewManager sharedPreviewManager] release];
    
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void QRSBHExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &QR_SBH_ContextInitializer;
    *ctxFinalizerToSet = &QR_SBH_ContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}

// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void QRSBHExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}