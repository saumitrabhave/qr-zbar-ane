//
//  CallZBar.m
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


#import "CameraPreviewManager.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


static CameraPreviewManager *sharedMyManager = nil;
static dispatch_once_t onceToken = 0;

@interface CameraPreviewManager ()
- (AVCaptureDevice*) getCameraDeviceAtPostion:(NSString*)postion;
- (void) resetPreviewManager;
- (void) addPreviewToStage;
- (void) removePreviewFromStage;
- (void) readerView:(ZBarReaderView*)readerView didReadSymbols:(ZBarSymbolSet*)symbols fromImage:(UIImage*)image;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
@property (nonatomic,retain,readwrite) NSDictionary* previewSizes;
@end

@implementation CameraPreviewManager

@synthesize readerView=_readerView;
@synthesize freContext=_freContext;
@synthesize imageScanner=_imageScanner;
@synthesize freRootView=_freRootView;
@synthesize previewSizes = _previewSizes;

@synthesize scanning=_scanning;
@synthesize previewing=_previewing;

+ (id)sharedPreviewManager {
    
    dispatch_once(&onceToken, ^{
        NSLog(@"Only Once Remember!!");
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self resetPreviewManager];
    }
    self.previewSizes = [NSDictionary dictionaryWithObjectsAndKeys:
                         AVCaptureSessionPreset1280x720,@"1280,720",
                         AVCaptureSessionPreset1920x1080,@"1920,1080",
                         AVCaptureSessionPreset352x288,@"352,288",
                         AVCaptureSessionPreset640x480,@"640,480",
                         AVCaptureSessionPresetiFrame1280x720,@"1280,720",
                         AVCaptureSessionPresetiFrame960x540,@"960,540",
                         nil];
    return self;
}

- (void)dealloc
{
    NSLog(@"Dealloc of CameraPreviewManager, Context is being Finalized");
    
    if(self.previewing){
        [self.readerView stop];
        [self removePreviewFromStage];
        self->_previewing = NO;
        self.scanning = NO;
    }
    self.imageScanner = nil;
    self.readerView = nil;
    sharedMyManager = nil;
    onceToken = 0;
    [super dealloc];
}

-(void) resetScanner
{
    if(self.imageScanner != nil){
        self.imageScanner = nil;
    }
    
    ZBarImageScanner* is = [[ZBarImageScanner alloc] init];
    self.imageScanner = is;
    [is release];            // imageScanner is reatain Property.
    
    // Set Defaults
    [self.imageScanner setSymbology:ZBAR_NONE config:ZBAR_CFG_X_DENSITY to:1];
    [self.imageScanner setSymbology:ZBAR_NONE config:ZBAR_CFG_Y_DENSITY to:1];
    [self.imageScanner setSymbology:ZBAR_NONE config:ZBAR_CFG_ENABLE to:0];
    [self.imageScanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
}

-(void) startPreviewWithCamera:(NSString*)cameraPosition atPostion:(CGRect)previewRect
{
    NSLog(@"Creating ReaderView");
    ZBarReaderView* rv = [[ZBarReaderView alloc] initWithImageScanner:self.imageScanner];
    self.readerView = rv;
    [rv release];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.readerView addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];
    
    NSLog(@"Setting Camera");
    self.readerView.device = [self getCameraDeviceAtPostion:cameraPosition];
    NSLog(@"Adding To Stage %f %f %f %f",
          previewRect.origin.x,
          previewRect.origin.y,
          previewRect.size.width,
          previewRect.size.height);
    self.readerView.frame = previewRect;
    self.readerView.torchMode = 0;
    _defaultResize = self.readerView.autoresizingMask;
    
    // Do Not AutoResize in case of custom postion or Size.
    if (previewRect.size.width != [self.freRootView bounds].size.width
        || previewRect.size.height != [self.freRootView bounds].size.height
        || previewRect.origin.x != 0
        || previewRect.origin.y != 0) {
        self.readerView.autoresizingMask = UIViewAutoresizingNone;
    }
    self.readerView.tracksSymbols = NO;
    [self addPreviewToStage];
    [self.readerView start];
    
    self.readerView.readerDelegate = self;
    NSLog(@"ReaderView RetainCount: %lu",(unsigned long)[self.readerView retainCount]);
}

-(void) stopPreview
{
    if (self.previewing) {
        NSLog(@"1");
        [self removePreviewFromStage];
        NSLog(@"2");
        self.readerView = nil;
        NSLog(@"Removed Preview and Stopped it");
    }
}

-(void) setOrientation:(UIInterfaceOrientation)orientation
{
    if(self.readerView != nil){
        NSLog(@"Moving to %d",orientation);
        [self.readerView willRotateToInterfaceOrientation:orientation duration:0];
        [self.readerView setNeedsLayout];
    }
}

-(void) pause
{
    if(self.previewing){
        [self.readerView stop];
    }
}

-(void) resume
{
    if(self.previewing){
        [self.readerView start];
    }
}

-(void) setX:(CGFloat)x andY:(CGFloat)y
{
    if(self.previewing){
        CGRect rect = CGRectMake(x, y, [self.readerView bounds].size.width, [self.readerView bounds].size.height);
        
        // AutoResize in case of Default FullScreen Mode.
        if (rect.size.width == [self.freRootView bounds].size.width
            && rect.size.height == [self.freRootView bounds].size.height
            && rect.origin.x == 0
            && rect.origin.y == 0) {
            self.readerView.autoresizingMask = _defaultResize;
        }else{
            self.readerView.autoresizingMask = UIViewAutoresizingNone;
        }
        
        self.readerView.frame = rect;
        [self.readerView setNeedsLayout];
    }
}

-(void) setWidth:(CGFloat)w andHeight:(CGFloat)h
{
    if(self.previewing){
        CGRect rect = CGRectMake([self.readerView bounds].origin.x, [self.readerView bounds].origin.y, w, h);
        
        // AutoResize in case of Default FullScreen Mode.
        if (rect.size.width == [self.freRootView bounds].size.width
            && rect.size.height == [self.freRootView bounds].size.height
            && rect.origin.x == 0
            && rect.origin.y == 0) {
            self.readerView.autoresizingMask = _defaultResize;
        }else{
            self.readerView.autoresizingMask = UIViewAutoresizingNone;
        }
        
        self.readerView.frame = rect;
        [self.readerView setNeedsLayout];
    }
}

/**
 A convinience method to get the Camera at desired location. The default behaviour
 is to get the Back Facing Camera
 
 @param postion A string represting the location of camera, use "front" for front
 camera and anything else including nil will return the back camera. Note that this
 parameter value is directly populated from ActionScript call
 
 @return AVCaptureDevice pointer representing the CameraDevice to be used as per the
    input parameter.
 */
- (AVCaptureDevice*) getCameraDeviceAtPostion:(NSString*)postion
{
    AVCaptureDevicePosition requiredPosition = AVCaptureDevicePositionBack;
    AVCaptureDevice* retDevice = nil;
    
    if ([postion isEqualToString:@"front"]) {
        requiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice* d in [AVCaptureDevice devices]) {
        if ([d position] == requiredPosition) {
            retDevice = d;
            break;
        }
    }
    
    NSLog(@"DeviceID %@",retDevice.modelID);
    return retDevice;
}

/**
 Reset all the properties and ivars of this instance so that it "Forgets" the current state and behaves as a newly instantiated
 object
 */
-(void) resetPreviewManager
{
    if(self.readerView != nil)
    {
        self.readerView = nil;
    }
    
    [self resetScanner];
    self->_freRootView = [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] view];
    self->_scanning = NO;
    self->_previewing = NO;
}

- (void) addPreviewToStage
{
    if(self.readerView != nil){
        NSLog(@"Adding the Subview");
        [self.freRootView addSubview:self.readerView];
        [self.freRootView bringSubviewToFront:self.readerView];
        self->_previewing = YES;
    }
}


- (void) removePreviewFromStage
{
    if(self.readerView != nil){
        NSLog(@"1.1");
        [self.readerView removeFromSuperview];
        NSLog(@"1.2");
        self->_previewing = NO;
    }
}

- (void) readerView:(ZBarReaderView*)readerView didReadSymbols:(ZBarSymbolSet*)symbols fromImage:(UIImage*)image
{
    for(ZBarSymbol* symbol in symbols)
    {
        NSLog(@"Found: %@",[symbol data]);
        NSString *event_name = @"data";
        if(self.scanning && FRE_OK == FREDispatchStatusEventAsync(self.freContext, (uint8_t*)[event_name UTF8String], (uint8_t*)[[symbol data] UTF8String])){
            NSLog(@"Event Fired!!");
        }else{
            NSLog(@"Not Fired :(");
        }
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    NSString* data = [NSString stringWithFormat:@"%fd,%fd",location.x,location.y];
    if(FRE_OK == FREDispatchStatusEventAsync(self.freContext, (uint8_t*)[@"previewTouched" UTF8String], (uint8_t*)[data UTF8String])){
        NSLog(@"Touch Event Fired!!");
    }else{
        NSLog(@"Touch Event Not Fired :(");
    }
}

- (NSString*) supportedPreviewSizes
{
    AVCaptureSession* currSession = [self.readerView session];
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[self.previewSizes count]];
    
    if(currSession != nil){
        [self.previewSizes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([currSession canSetSessionPreset:obj]){
                    [result addObject:key];
            }
        }];
    }
    
    NSString* val = [result componentsJoinedByString:@":"];
    NSLog(@"Returning %@",val);
    return val;
}

- (void) setPreviewWidth:(int)w andHeight:(int)h
{
    AVCaptureSession* currSession = [self.readerView session];
    NSString* keyString = [NSString stringWithFormat:@"%d,%d",w,h];
    
    if(currSession != nil){
        [self.previewSizes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([keyString isEqualToString:key] && [currSession canSetSessionPreset:obj]){
                NSLog(@"Setting PreviewSizePreset To: %@",obj);
                [currSession setSessionPreset:obj];
            }
        }];
    }
}

@end
