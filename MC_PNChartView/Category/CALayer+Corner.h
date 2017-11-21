//
//  CALayer+Corner.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    cornerTop = 0,
    cornerBottom,
    cornerLeft,
    cornerRight,
} CornerdDirection;

@interface CALayer (Corner)

+ (CAShapeLayer *) cornerLayerInRect:(CGRect)rect cornerDirection:(CornerdDirection)direction edge:(CGFloat)edge radius:(CGFloat) radius ;

@end
