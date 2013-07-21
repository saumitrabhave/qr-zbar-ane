//
//  QRZBar.m
//  QRZBar
//
//  Created by Saumitra R Bhave on 20 January 2013.
//  Copyright (c) 2013 Saumitra. All rights reserved.
//
#import "FlashRuntimeExtensions.h"
#import "CallZBar.h"
#import "QROverlay.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

FREObject QR_SBH_setConfig(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    NSLog(@"Call setConfig");
    
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    
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
    
    ZBarImageScanner* scanner = zBar.reader.scanner;
    [scanner setSymbology:symbology config:config to:val];
    
    return NULL;
}

FREObject QR_SBH_reset(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    
    if(!zBar.isRunning)
    {
        [zBar resetZBarController];
    }
    return NULL;
}

FREObject QR_SBH_start(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    FREObject retVal = NULL;
    
    if(argc != 1) { NSLog(@"Expected exactly 1 argument."); return NULL;}
    
    uint32_t singleScan = 1;
    FREGetObjectAsBool(argv[0], &singleScan);
    
    if(!zBar.isRunning)
    {
        [zBar scanWithMode:singleScan];
        
        FRENewObjectFromBool((uint32_t)YES, &retVal);
    }else{
        FRENewObjectFromBool((uint32_t)NO, &retVal);
    }
    
    return retVal;
}

FREObject QR_SBH_targetArea(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    uint32_t len,nc,sc,sz;
    uint8_t* frStr;
    NSScanner *scanner = nil;
    
    if(argc < 3)
    {
        NSLog(@"Not enough arguments");
        return nil;
    }

    QROverlay* o = (QROverlay*)zBar.reader.cameraOverlayView;
    
    FREGetObjectAsUint32(argv[0], &sz);
    o.targetSize = sz;
    
    FREGetObjectAsUTF8(argv[1],&len,(const uint8_t**) &frStr);
    scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:frStr]];
    [scanner scanHexInt:&nc];
    NSLog(@"NORMAL:%x",nc);
    o.normalColor = UIColorFromRGB(nc);
    
    FREGetObjectAsUTF8(argv[2],&len,(const uint8_t**) &frStr);
    scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:frStr]];
    [scanner scanHexInt:&sc];
    NSLog(@"SUCCESS:%x",sc);
    o.successColor = UIColorFromRGB(sc);
    
    NSLog(@"SIZE:%d NORMAL:%x SUCCESS:%x",sz,nc,sc);
    
    o.captured =NO;
    [o setNeedsDisplay];
    
    return NULL;
}

FREObject QR_SBH_launchStatus(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    FREObject retVal = NULL;
    
    FRENewObjectFromBool((uint32_t)zBar.isRunning, &retVal);
    
    return retVal;
}

FREObject QR_SBH_stop(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    CallZBar *zBar = nil;
    FREGetContextNativeData(ctx, (void**)&zBar);
    FREObject retVal = NULL;
    
    if(zBar.isRunning)
    {
        [zBar cancelScan];
        FRENewObjectFromBool((uint32_t)YES, &retVal);
    }else{
        FRENewObjectFromBool((uint32_t)NO, &retVal);
    }
    
    return retVal;
}

//------------------------------------
//
// Required Methods.
//
//------------------------------------

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void QR_SBH_ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    CallZBar *zBar = [[CallZBar alloc] initWithFREContext:&ctx];
    FRESetContextNativeData(ctx, zBar);
    
	*numFunctionsToTest = 6;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 6);
	func[0].name = (const uint8_t*) "setConfig";
	func[0].functionData = NULL;
    func[0].function = &QR_SBH_setConfig;
    
    func[1].name = (const uint8_t*) "reset";
	func[1].functionData = NULL;
    func[1].function = &QR_SBH_reset;
    
    func[2].name = (const uint8_t*) "start";
	func[2].functionData = NULL;
    func[2].function = &QR_SBH_start;
    
    func[3].name = (const uint8_t*) "targetArea";
	func[3].functionData = NULL;
    func[3].function = &QR_SBH_targetArea;
    
    func[4].name = (const uint8_t*) "launchStatus";
	func[4].functionData = NULL;
    func[4].function = &QR_SBH_launchStatus;
    
    func[5].name = (const uint8_t*) "stop";
	func[5].functionData = NULL;
    func[5].function = &QR_SBH_stop;
    
	*functionsToSet = func;
}

// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void QR_SBH_ContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    
    void *zbar = NULL;
    FREGetContextNativeData(ctx, &zbar);
    
    CallZBar *zbarPtr = (CallZBar*)zbar;
    [zbarPtr release];
    
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