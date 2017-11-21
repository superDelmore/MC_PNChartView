//
//  LineLayer.m
//  PNChartDemo
//
//  Created by mc on 2017/11/9.
//  Copyright © 2017年 kevinzhow. All rights reserved.
//

#import "LineLayer.h"
#import "PNPieChartDataItem.h"
#import "NSString+Size.h"

@interface LineLayer ()

@property (strong, nonatomic) NSMutableArray<NSValue *> *textFrames;

@property (strong, nonatomic) NSMutableArray<CALayer *> *layers;


@end

@implementation LineLayer

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_angels[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    return [_angels[index] floatValue];
}


- (void) drawInContext:(CGContextRef)ctx {
    
    for (CALayer *layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    [self.layers removeAllObjects];
    float radius_end = -90;
    for (int i = 0; i < _angels.count; i++) {
        CGFloat startAngle = [self startPercentageForItemAtIndex:i];
        CGFloat endAngle = [self endPercentageForItemAtIndex:i];
        CGFloat centerPercentage = (endAngle - startAngle )/ 2 + startAngle;
        //    CGFloat rad = centerPercentage * 2 * M_PI;
        CGFloat rad = centerPercentage * 360;
        PNPieChartDataItem *currentDataItem = _dataItems[i];
        NSString *titleText = currentDataItem.textDescription;
        
        NSString *titleValue;
        
        if (self.showAbsoluteValues) {
            titleValue = [NSString stringWithFormat:@"%.0f",currentDataItem.value];
        }else{
            titleValue = [NSString stringWithFormat:@"%.2f%%",(endAngle - startAngle) * 100];
        }
        CGSize size = CGSizeZero;
        if (self.hideValues){
//            size = [titleText sizeWithAttributes:@{NSFontAttributeName:_descriptionTextFont}];
            size = [titleText sizeWithFont:_descriptionTextFont constrainedToWidth:CGRectGetWidth(self.frame)/2.0-_radiu-5];
            titleValue = titleText;
        }else if(!titleText || self.showOnlyValues){
//            size = [titleValue sizeWithAttributes:@{NSFontAttributeName:_descriptionTextFont}];
            size = [titleText sizeWithFont:_descriptionTextFont constrainedToWidth:CGRectGetWidth(self.frame)/2.0-_radiu-5];

        }else {
            NSString* str = [titleText stringByAppendingString:[NSString stringWithFormat:@"%@",titleValue]];
//            size = [str sizeWithAttributes:@{NSFontAttributeName:_descriptionTextFont}];
            size = [str sizeWithFont:_descriptionTextFont constrainedToWidth:CGRectGetWidth(self.frame)/2.0-_radiu-5];
            titleValue = str;
        }
//        NSLog(@"center 1 = %@",NSStringFromCGPoint(CGPointMake(self.cirX, self.cirY)));
        
        //牵引线开始
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        radius_end = endAngle * 360.0-90;
        
        CGPoint point = [self getPostionX:_cirX  postionY:_cirY radius:_radiu cirAngle:rad];
        [path moveToPoint:point];
//        NSLog(@"point 1 = %@",NSStringFromCGPoint(point));
        // 延伸
//        CGPoint point2 = [self getPostionX:_cirX postionY:_cirY radius:_radiu+10 cirAngle:rad];
//        CGPoint point2 = [self textFramePostionX:_cirX postionY:_cirY radius:_radiu cirAngle:rad size:size maxWidth:CGRectGetWidth(self.frame)];
        NSArray<NSValue *> *array = [self textFramePostionX:_cirX postionY:_cirY radius:_radiu+5 cirAngle:rad text:titleValue maxWidth:CGRectGetWidth(self.frame)];
        CGPoint point2 = [array.firstObject CGPointValue];
        CGRect textRect = [array.lastObject CGRectValue];
        
       
        [path addLineToPoint:point2];
        if (rad > 0 && rad < 180) { // 右边的线
            CGPoint point3 = CGPointMake(CGRectGetMinX(textRect), point2.y);
            [path addLineToPoint: point3];
        } else {
            CGPoint point3 = CGPointMake(CGRectGetMaxX(textRect), point2.y);
            [path addLineToPoint: point3];
        }
        
        lineLayer.strokeColor   = currentDataItem.color.CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.lineWidth = 1.0;
        lineLayer.path = path.CGPath;
        [self addSublayer:lineLayer];
        [self.layers addObject:lineLayer];
        
        
        CATextLayer *textlayer = [CATextLayer layer];
        textlayer.contentsScale = [UIScreen mainScreen].scale;
        textlayer.wrapped = YES;
        textlayer.string = titleValue ;

        //    textlayer.bounds = CGRectMake(0, 0, size.width, size.height);
        textlayer.frame = textRect;
        textlayer.fontSize = _descriptionTextFont.pointSize;
        textlayer.foregroundColor = currentDataItem.color.CGColor;
        textlayer.alignmentMode = @"center";
        //    textlayer.backgroundColor = [UIColor redColor].CGColor;
        [_textFrames addObject:[NSValue valueWithCGRect:textRect]];
        [self addSublayer:textlayer];
        [self.layers addObject:textlayer];

    }
   
     
}


/**
 如果两个frame有交叉则重新生成新的frame

 @param frame 要比较的frame
 @return 新的和 frame 无交叉的fram
 */
- (BOOL) filterIntersectFrame:(CGRect)frame {
    BOOL isFrameIntersect = false;
    for (NSValue *value in self.textFrames) {
        CGRect rect = [value CGRectValue];
        if (CGRectIntersectsRect(rect, frame)) {
            //有交叉
            isFrameIntersect = true;
            break;
        }
    }
    return isFrameIntersect;
}

- (NSArray *) textFramePostionX:(CGFloat)cirX postionY:(CGFloat)cirY radius:(CGFloat)radiu cirAngle:(CGFloat)cirAngle text:(NSString *)text maxWidth:(CGFloat)maxWidth{
    CGSize size = CGSizeZero;
    CGRect rect = CGRectZero;
    CGPoint point2 = [self getPostionX:cirX postionY:cirY radius:radiu cirAngle:cirAngle];
    // 折线
    CGFloat line_x;
    CGFloat label_x;
    
    if (cirAngle > 0 && cirAngle < 180) { // 右边的线
        CGFloat maxTextWidth = maxWidth-point2.x-5;
        CGSize textMaxSize = [text sizeWithFont:_descriptionTextFont constrainedToWidth:maxTextWidth];
        size = textMaxSize;
        
        line_x = maxWidth  - size.width-5;
        label_x  = line_x + size.width / 2;
        
        if (point2.x + size.width > maxWidth) {
            point2.x = maxWidth - size.width;
//            size.width = (size.width+2)/2.0;
//            size.height = size.height*2;
        }
    } else {
        CGFloat maxTextWidth = point2.x-5;
        CGSize textMaxSize = [text sizeWithFont:_descriptionTextFont constrainedToWidth:maxTextWidth];
        size = textMaxSize;

        line_x = size.width;
        label_x = size.width - size.width / 2+5;
        if (point2.x < size.width) {
            point2.x = size.width;
        }
    }
    
   rect = CGRectMake(label_x-size.width/2.0, point2.y-size.height/2.0, size.width, size.height);
    if (rect.origin.y < -20) {
        //如果最上面超出屏幕则直接返回
        return @[[NSValue valueWithCGPoint:point2],[NSValue valueWithCGRect:rect]];
    }
    if ([self filterIntersectFrame:rect]) {
        //如果有交叉，递归直到得出没有交叉frame
       return [self textFramePostionX:cirX postionY:cirY radius:radiu+2 cirAngle:cirAngle text:text maxWidth:maxWidth-20];
    }else {
//        return point2;
        return @[[NSValue valueWithCGPoint:point2],[NSValue valueWithCGRect:rect]];
    }
}

/**
 *  验证码请求字典
 *
 *  @param cirX 中心点x坐标
 *  @param cirY 中心点y坐标
 *  @param radiu 半径
 *  @param cirAngle 旋转角度
 *
 *  @return
 */
- (CGPoint)getPostionX:(CGFloat)cirX postionY:(CGFloat)cirY radius:(CGFloat)radiu cirAngle:(CGFloat)cirAngle
{
    CGPoint point;
    CGFloat posX = 0.0;
    CGFloat posY = 0.0;
    CGFloat arcAngle = M_PI * cirAngle / 180.0;
 
    if (cirAngle == 0) {
        posX = cirX ;
        posY = cirY - radiu;
    }else if (cirAngle < 90) {
        posX = cirX + sin(arcAngle) * radiu;
        posY = cirY - cos(arcAngle) * radiu;
    } else if (cirAngle == 90) {
        posX = cirX + radiu;
        posY = cirY ;
    } else if (cirAngle > 90 && cirAngle < 180) {
        arcAngle = M_PI * (180 - cirAngle) / 180.0;
        posX = cirX + sin(arcAngle) * radiu;
        posY = cirY + cos(arcAngle) * radiu;
    } else if (cirAngle == 180) {
        posX = cirX ;
        posY = cirY + radiu;
    } else if (cirAngle > 180 && cirAngle < 270) {
        arcAngle = M_PI * (cirAngle - 180) / 180.0;
        posX = cirX - sin(arcAngle) * radiu;
        posY = cirY + cos(arcAngle) * radiu;
    } else if (cirAngle == 270) {
        posX = cirX - radiu;
        posY = cirY;
    } else if(cirAngle > 270 && cirAngle < 360){
        arcAngle = M_PI * (360 - cirAngle) / 180.0;
        posX = cirX - sin(arcAngle) * radiu;
        posY = cirY - cos(arcAngle) * radiu;
    }
    point.x = posX;
    point.y = posY;
    
    
    
    return point;
}

- (NSMutableArray *) textFrames {
    if (!_textFrames) {
        _textFrames = [NSMutableArray arrayWithCapacity:0];
    }
    return _textFrames;
}

- (NSMutableArray<CALayer *> *) layers {
    if (!_layers) {
        _layers = [NSMutableArray arrayWithCapacity:0];
    }
    return _layers;
}

@end
