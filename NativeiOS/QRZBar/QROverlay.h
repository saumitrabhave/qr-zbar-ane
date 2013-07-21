//
//  QROverlay.h
//  QRZBar
//
//  Created by Saumitra Bhave on 22/01/13.
//  Copyright (c) 2013 RANCON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QROverlay : UIView
{
    CGFloat targetSize;
    UIColor* normalColor;
    UIColor* successColor;
    Boolean captured;
}
@property (nonatomic) CGFloat targetSize;
@property (nonatomic) Boolean captured;
@property (retain,nonatomic) UIColor* normalColor;
@property (retain,nonatomic) UIColor* successColor;
@end
