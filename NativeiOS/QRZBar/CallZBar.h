//
//  CallZBar.h
//  QRZBar
//
//  Created by JAN HEUFF on 15/02/2012.
//  Copyright (c) 2012 RANCON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>

@interface CallZBar : NSObject < ZBarReaderDelegate >
{
    FREContext *context;
    ZBarReaderViewController *reader;
    Boolean isRunning;
    uint32_t singleScan;
    Boolean doOnce;
}

@property (readonly, nonatomic) ZBarReaderViewController *reader;
@property (nonatomic) Boolean isRunning;

-(id) initWithFREContext:(FREContext*)ctx;
-(void) scanWithMode:(uint32_t)mode andCamera:(NSString*)cameraPosition;
-(void) cancelScan;
-(void) resetZBarController;
-(void)dealloc;

@end
