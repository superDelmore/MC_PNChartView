//
//  BarChartView.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "BarChartView.h"
#import "UIColor+RandColor.h"
#import "UIView+Extension.h"
#import "PNBarChart.h"

@interface BarChartView()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) PNBarChart *PNBarchart;

@property (strong, nonatomic) UIView *blankView;

@end

@implementation BarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = chartViewBackgroundColor();
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
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
        
        static NSNumberFormatter *barChartFormatter;
        if (!barChartFormatter) {
            barChartFormatter = [[NSNumberFormatter alloc] init];
            barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            barChartFormatter.allowsFloats = NO;
            barChartFormatter.maximumFractionDigits = 0;
        }
    
        PNBarChart *barchartView = [[PNBarChart alloc] initWithFrame:CGRectMake(10, 40, frame.size.width-20, self.frame.size.height-40-20)];
        barchartView.yChartLabelWidth = 20.0;
        barchartView.chartMarginLeft = 30.0;
        barchartView.chartMarginRight = 10.0;
        barchartView.chartMarginTop = 5.0;
        barchartView.chartMarginBottom = 10.0;
        barchartView.yLabelFormatter = ^(CGFloat yValue) {
            return [barChartFormatter stringFromNumber:@(yValue)];
        };
        
        barchartView.labelMarginTop = 5.0;
        barchartView.showChartBorder = YES;

        barchartView.isGradientShow = NO;
        barchartView.isShowNumbers = YES;
        self.PNBarchart = barchartView;
        
        
        [self addSubview:barchartView];

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

- (void) drawLineChartLineView:(NSArray<NSDictionary *> *)datasource{
    if (datasource.count == 0) {
        [self addSubview:self.blankView];
        return;
    }
    __block NSMutableArray<NSString *> *nameArray = [NSMutableArray arrayWithCapacity:datasource.count];
    __block NSMutableArray<NSNumber *> *numberArray = [NSMutableArray arrayWithCapacity:datasource.count];
    __block CGFloat maxValue = 0;
    [datasource enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *number = [obj objectForKey:@"snum"];
        [nameArray addObject:[obj objectForKey:@"name"]];
        [numberArray addObject:number];
        maxValue = MAX(maxValue, [number floatValue]);
    }];
    if (maxValue == 0) {
        [self addSubview:self.blankView];
        return;
    }
    if (_blankView.superview) {
        [_blankView removeFromSuperview];
        _blankView = nil;
    }
    self.PNBarchart.xLabels = nameArray;
    self.PNBarchart.yValues = numberArray;
    [self.PNBarchart strokeChart];
    
}


- (void)AAChartViewDidFinishLoad {
 
}

- (UIView *) blankView {
    if (!_blankView) {
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width-20, self.frame.size.height-40-20)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
