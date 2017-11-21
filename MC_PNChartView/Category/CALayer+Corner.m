//
//  CALayer+Corner.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "CALayer+Corner.h"

@implementation CALayer (Corner)


+ (CAShapeLayer *) cornerLayerInRect:(CGRect)rect cornerDirection:(CornerdDirection)direction edge:(CGFloat)edge radius:(CGFloat) radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint leftTopPoint = CGPointMake(x, y);
    CGPoint leftBottomPoint = CGPointMake(x, y+height);
    CGPoint rightTopPoint = CGPointMake(x+width, y);
    CGPoint rightBottomPoint = CGPointMake(x+width, y+height);
    
    CGFloat widthLength = radius*cos(M_PI_4);
    CGFloat heightLength = radius*sin(M_PI_4);

    [bezierPath moveToPoint:leftTopPoint];

    if (direction == cornerTop) {
        [bezierPath addLineToPoint:CGPointMake(x+edge, y)];
        [bezierPath addLineToPoint:CGPointMake(x+edge+widthLength, y-heightLength)];
        [bezierPath addLineToPoint:CGPointMake(x+edge+2*widthLength, y)];
        [bezierPath addLineToPoint:rightTopPoint];
        [bezierPath addLineToPoint:rightBottomPoint];
        [bezierPath addLineToPoint:leftBottomPoint];
    }else if(direction == cornerBottom) {
        [bezierPath addLineToPoint:leftBottomPoint];
        [bezierPath addLineToPoint:CGPointMake(x+edge, y+height)];
        [bezierPath addLineToPoint:CGPointMake(x+edge+widthLength,y+height+heightLength)];
        [bezierPath addLineToPoint:CGPointMake(x+edge+2*widthLength, y+height)];
        [bezierPath addLineToPoint:rightBottomPoint];
        [bezierPath addLineToPoint:rightTopPoint];
    }else if (direction == cornerLeft) {
        [bezierPath addLineToPoint:CGPointMake(x, y+edge)];
        [bezierPath addLineToPoint:CGPointMake(x -heightLength , y+edge+widthLength)];
        [bezierPath addLineToPoint:CGPointMake(x, y+2*widthLength)];
        [bezierPath addLineToPoint:leftBottomPoint];
        [bezierPath addLineToPoint:rightBottomPoint];
        [bezierPath addLineToPoint:rightTopPoint];
    }else if (direction == cornerRight) {
        [bezierPath addLineToPoint:rightTopPoint];
        [bezierPath addLineToPoint:CGPointMake(x+width, y+edge)];
        [bezierPath addLineToPoint:CGPointMake(x+width+heightLength,y+edge+widthLength)];
        [bezierPath addLineToPoint:CGPointMake(x+width,y+edge+2*widthLength)];
        [bezierPath addLineToPoint:rightBottomPoint];
        [bezierPath addLineToPoint:leftBottomPoint];
    }
    [bezierPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.0;
    layer.path = bezierPath.CGPath;
    
    return layer;
}
@end
