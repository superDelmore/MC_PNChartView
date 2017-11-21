//
//  LineChartView.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "LineChartView.h"
#import "UIColor+RandColor.h"
#import "PNLineChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import "NSString+Size.h"
#import "MathMethods.h"
#import "CALayer+Corner.h"
#import "UIView+Extension.h"

@interface LineChartView()<PNChartDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) PNLineChart *PNLineChart;

@property (strong, nonatomic) UIScrollView *chartBgScroll;

@property (strong, nonatomic) UIView *blankView;

@end


@implementation LineChartView

{
    NSInteger _selectPointIndex;
    CALayer *_selectLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = chartViewBackgroundColor();
        _selectPointIndex = -1;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        bgView.backgroundColor = chartViewContentBgColor();
        bgView.layer.borderColor = chartViewTitleBgBorderColor().CGColor;
        bgView.layer.borderWidth = 0.5;
        [self addSubview:bgView];
        
        UILabel *subTitle = [UILabel new];
        subTitle.textColor = chartViewTitleTextColor();
        subTitle.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:subTitle];
        self.subTitleLabel = subTitle;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = chartViewTitleTextColor();
        titleLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        self.chartBgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, frame.size.width-20, self.frame.size.height-50-10)];
        self.chartBgScroll.showsHorizontalScrollIndicator = false;
        [self addSubview:self.chartBgScroll];
        
    }
    return self;
}

- (void) setChartTitle:(NSString *) titleString {
    self.titleLabel.text = titleString;
    CGSize size = [titleString sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    if (self.subTitleLabel.text.length > 0) {
        self.titleLabel.frame = CGRectMake(10, 0, CGRectGetMinX(self.subTitleLabel.frame)-10-10, self.subTitleLabel.superview.bounds.size.height);
    }else {
        self.titleLabel.frame = CGRectMake(10, 0, MIN(self.subTitleLabel.superview.bounds.size.width-size.width-20, size.width), self.subTitleLabel.superview.bounds.size.height);
    }
}

- (void) setChartSubTitle:(NSString *) subTitleString {
    self.subTitleLabel.text = subTitleString;
    CGSize size = [subTitleString sizeWithAttributes:@{NSFontAttributeName:self.subTitleLabel.font}];
    self.subTitleLabel.frame = CGRectMake(self.subTitleLabel.superview.bounds.size.width-size.width-10, 0, MIN(self.subTitleLabel.superview.bounds.size.width-size.width-20, size.width), self.subTitleLabel.superview.bounds.size.height);
    if (self.titleLabel.text.length > 0) {
        self.titleLabel.frame = CGRectMake(10, 0, CGRectGetMinX(self.subTitleLabel.frame)-10-10, self.subTitleLabel.superview.bounds.size.height);
    }
}

- (void) drawLineChartLineView:(NSArray<NSDictionary *> *)datasource {
    if (datasource.count == 0) {
        [self addSubview:self.blankView];
        if (_PNLineChart) {
            [_PNLineChart removeFromSuperview];
            _PNLineChart = nil;
        }
        return;
    }
    __block NSMutableArray<NSString *> *nameArray = [NSMutableArray arrayWithCapacity:datasource.count];
    __block NSMutableArray<NSNumber *> *numberArray = [NSMutableArray arrayWithCapacity:datasource.count];
    __block float maxValue = 0;
    [datasource enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *snum = [obj objectForKey:@"snum"];
        maxValue = MAX([snum floatValue], maxValue);
        if ([obj objectForKey:@"perdate"]) {
            [nameArray addObject:[obj objectForKey:@"perdate"]];
            
        }else if ([obj objectForKey:@"name"]) {
            [nameArray addObject:[obj objectForKey:@"name"]];
        }
        [numberArray addObject:snum];
    }];
    if (maxValue == 0) {
        maxValue = 10;
    }else {
        maxValue = maxValue * 1.1;
    }
    
    NSArray *ylabels = convertToStringArray(arithmeticProgression(0.0, maxValue, 6));      
    
    if (nameArray.count == 1) {
        [nameArray insertObject:@" " atIndex:0];
        [numberArray insertObject:@(0) atIndex:0];
    }
    
//    if (maxValue == 0) {
//        [self addSubview:self.blankView];
//        return;
//    }
    if (_blankView.superview) {
        [_blankView removeFromSuperview];
        _blankView = nil;
    }
    if (_PNLineChart) {
        [_PNLineChart removeFromSuperview];
        _PNLineChart = nil;
    }
    
    CGFloat marginLeft = 30.0f;
    CGFloat maxWidth = MAX(numberArray.count * 30.0 + 2 * marginLeft, self.frame.size.width-20);
    self.chartBgScroll.contentSize = CGSizeMake(maxWidth, self.chartBgScroll.frame.size.height);
    //数组属性，chartMarginLeft，chartMarginRight,chartMarginTop,chartMarginBottom,xLabelWidth 等参数要在yLabels和xLabels之前设置
    self.PNLineChart.xLabelWidth = 30.0;
    self.PNLineChart.chartMarginLeft = self.PNLineChart.chartMarginRight = marginLeft;
    self.PNLineChart.yFixedValueMax = maxValue;
    self.PNLineChart.xLabels = nameArray;
    self.PNLineChart.yLabels = ylabels;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = self.titleLabel.text;
    data01.pointLabelColor = [UIColor blackColor];
    data01.alpha = 1.0f;
    data01.color = [UIColor colorWithRed:0.32 green:0.51 blue:0.73 alpha:1.00];
//    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    data01.itemCount = numberArray.count;
//    data01.inflexionPointColor = [UIColor redColor];
    data01.inflexionPointStyle = PNLineChartPointStyleNone;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [numberArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.PNLineChart.chartData = @[data01];
    [self.PNLineChart strokeChart];
    [self.chartBgScroll addSubview:self.PNLineChart];

}

/**
 显示所在点的数据信息

 @param itemData 数据模型
 @param point 坐标
 */
- (void) showTuchedPointInfo:(PNLineChartDataItem *)itemData point:(CGPoint) point{
    if (_selectLayer) {
        [_selectLayer removeFromSuperlayer];
        _selectLayer = nil;
    }
    
    CALayer *infoLayer = [CALayer layer];
//    infoLayer.borderWidth = 1.0f;
//    infoLayer.borderColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00].CGColor;
//    infoLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGPoint newPoint = [self.PNLineChart convertPoint:point toView:self.chartBgScroll];
    CATextLayer *moneyLayer = [CATextLayer layer];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSMutableString stringWithFormat:@"金额：¥%.2f",itemData.y]];
    NSMutableParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    [attrString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, attrString.length)];
    moneyLayer.string = attrString;
    moneyLayer.contentsScale = [UIScreen mainScreen].scale;
    moneyLayer.backgroundColor = [UIColor clearColor].CGColor;
    moneyLayer.alignmentMode = @"center";
    CGFloat maxHeight = self.PNLineChart.height-self.PNLineChart.chartMarginBottom;
    CGSize size = attrString.size;
    CGSize newSize = CGSizeMake(size.width+10, size.height+10);
    CGRect rect = CGRectMake(newPoint.x-size.width/2.0-5, newPoint.y-newSize.height-5, newSize.width, newSize.height);
    if (CGRectGetMaxY(rect)>=maxHeight) {
        rect.origin.y = maxHeight-newSize.height-5;
    }
    infoLayer.frame = rect;
    CAShapeLayer *maskLayer = [CAShapeLayer cornerLayerInRect:infoLayer.bounds cornerDirection:cornerBottom edge:size.width/2.0 radius:5];
    [infoLayer addSublayer:maskLayer];
    moneyLayer.frame = CGRectMake(5, 5, size.width, size.height);
    [infoLayer addSublayer:moneyLayer];
    [self.chartBgScroll.layer addSublayer:infoLayer];
    _selectLayer = infoLayer;
}

#pragma mark - PNChartDelegate Methods
/**
 * Callback method that gets invoked when the user taps on the chart line.
 */
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"touch line");
}

/**
 * Callback method that gets invoked when the user taps on a chart line key point.
 */
- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex {
    /*
    NSLog(@"touch join point = %@",NSStringFromCGPoint(point));
    if (_selectPointIndex == pointIndex) {
        return;
    }
    _selectPointIndex = pointIndex;
    PNLineChartData *lineChartData = self.PNLineChart.chartData.firstObject;
    PNLineChartDataItem *item = lineChartData.getData(pointIndex);
    [self showTuchedPointInfo:item point:point];
    */
}


- (UIView *) blankView {
    if (!_blankView) {
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50-10)];
        _blankView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _blankView.width-20, 20)];
        label.centerY = _blankView.height/2.0;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.text = @"暂无数据";
        label.textAlignment = NSTextAlignmentCenter;
        [_blankView addSubview:label];
    }
    return _blankView;
}

- (PNLineChart *)PNLineChart {
    if (!_PNLineChart) {
        _PNLineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, self.chartBgScroll.contentSize.width, self.chartBgScroll.frame.size.height)];
        _PNLineChart.backgroundColor = [UIColor clearColor];
        _PNLineChart.showCoordinateAxis = YES;
        _PNLineChart.yLabelFormat = @"%1.1f";
        _PNLineChart.showGenYLabels = YES;
        _PNLineChart.xLabelFont = [UIFont systemFontOfSize:9.0];
        _PNLineChart.yLabelFont = [UIFont systemFontOfSize:9.0];
        _PNLineChart.backgroundColor = [UIColor whiteColor];
        _PNLineChart.yGridLinesColor = [UIColor grayColor];
        [_PNLineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];
        _PNLineChart.yLabelColor = [UIColor blackColor];
        _PNLineChart.xLabelColor = [UIColor blackColor];
        //        lineChart.xLabelWidth = 20.0;
        // added an example to show how yGridLines can be enabled
        // the color is set to clearColor so that the demo remains the same
        _PNLineChart.showGenYLabels = NO;
        _PNLineChart.showYGridLines = YES;
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        _PNLineChart.yFixedValueMin = 0.0;
        _PNLineChart.delegate = self;
//            self.PNLineChart.chartMarginTop = self.PNLineChart.chartMarginBottom = 15;

    }
    return _PNLineChart;
}

@end
