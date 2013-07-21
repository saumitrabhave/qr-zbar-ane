//
//  QROverlay.m
//  QRZBar
//
//  Created by Saumitra Bhave on 22/01/13.
//  Copyright (c) 2013 Saumitra Bhave. All rights reserved.
//

#import "QROverlay.h"



@implementation QROverlay
@synthesize targetSize;
@synthesize successColor;
@synthesize normalColor;
@synthesize captured;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizesSubviews=YES;
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.backgroundColor = [UIColor clearColor];
        self.targetSize = 100;
        self.successColor = [UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:1.0];
        self.normalColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:1.0];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat lineSize= 15;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!self.captured){
        NSLog(@"Color:%@",self.normalColor);
        CGContextSetStrokeColorWithColor(context, self.normalColor.CGColor);
    }
    else{
        NSLog(@"Color:%@",self.successColor);
        CGContextSetStrokeColorWithColor(context, self.successColor.CGColor);
    }
    CGContextSetLineWidth(context, 2.0);
    
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    //Top-Left
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2 + lineSize, centerY-targetSize/2);
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2, centerY-targetSize/2 + lineSize);
    
    //Top-Right
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2 - lineSize, centerY-targetSize/2);
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY-targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2, centerY-targetSize/2 + lineSize);
    
    
    //Bottom-Left
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2 + lineSize, centerY+targetSize/2);
    CGContextMoveToPoint(context, centerX-targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX-targetSize/2, centerY+targetSize/2 - lineSize);
    
    //Bottom-Right
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2 - lineSize, centerY+targetSize/2);
    CGContextMoveToPoint(context, centerX+targetSize/2,centerY+targetSize/2);
    CGContextAddLineToPoint(context ,centerX+targetSize/2, centerY+targetSize/2 - lineSize);
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
