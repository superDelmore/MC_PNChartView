//
//  PieChartView.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "PieChartView.h"
#import "UIColor+RandColor.h"
#import "PNPieChart.h"
#import "PNPieChartDataItem.h"
#import "UIView+Extension.h"

@interface PieChartView()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) PNPieChart *pieChart;

@property (strong, nonatomic) UIView *blankView;

@end

@implementation PieChartView

{
    NSArray<PNPieChartDataItem *> *_items;
    
    UIView *_legendView;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = chartViewBackgroundColor();
        self.isPercent = false;
        self.showPullLine = true;
        self.showOnlyValues = false;
        self.showNumberLabel = false;
        self.showlegendValue = false;
        self.showLegendView = true;
    }
    return self;
}

- (void) setChartTitle:(NSString *) titleString {
    if ([self.titleLabel.text isEqualToString:titleString]) {
        return;
    }
    if (!self.titleLabel.superview) {
        if (!self.bgView.superview) {
            [self addSubview:self.bgView];
        }
        [self.bgView addSubview:self.titleLabel];
    }
    self.titleLabel.text = titleString;
    CGSize size = [titleString sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    if (_subTitleLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(10, 0, CGRectGetMinX(self.subTitleLabel.frame)-10-10, self.bgView.height);
    }else {
        self.titleLabel.frame = CGRectMake(10, 0, MIN(self.bgView.width-size.width-20, size.width), self.bgView.height);
    }
}

- (void) setChartSubTitle:(NSString *) subTitleString {
    if ([self.subTitleLabel.text isEqualToString:subTitleString]) {
        return;
    }
    if (!self.subTitleLabel.superview) {
        if (!self.bgView.superview) {
            [self addSubview:self.bgView];
        }
        [self.bgView addSubview:self.subTitleLabel];
    }
    self.subTitleLabel.text = subTitleString;
    CGSize size = [subTitleString sizeWithAttributes:@{NSFontAttributeName:self.subTitleLabel.font}];
    self.subTitleLabel.frame = CGRectMake(self.bgView.width-size.width-10, 0, MIN(self.subTitleLabel.superview.bounds.size.width-size.width-20, size.width), self.bgView.height);
    if (_titleLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(10, 0, CGRectGetMinX(self.subTitleLabel.frame)-10-10, self.bgView.height);
    }
}

- (void) drawPieChartView:(NSArray *)datasource {
    if (datasource.count == 0) {
        [self addSubview:self.blankView];
        return;
    }
    
    __block NSMutableArray<PNPieChartDataItem *> *items = [NSMutableArray arrayWithCapacity:datasource.count];
    __block CGFloat maxValue = 0;
    
    [datasource enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[[obj objectForKey:@"snum"] floatValue] color:randColor() description:[obj objectForKey:@"name"]];
            [items addObject:item];
            maxValue = MAX(maxValue, [[obj objectForKey:@"snum"] floatValue]);
       
    }];
    _items = items;
    if (maxValue == 0) {
        [self addSubview:self.blankView];
        return;
    }
    if (_blankView.superview) {
        [_blankView removeFromSuperview];
        _blankView = nil;
    }
    if (_pieChart) {
        [_pieChart removeFromSuperview];
        _pieChart = nil;
    }
    [self addSubview:self.pieChart];
    
    if (self.showLegendView) {
        self.pieChart.legendStyle = PNLegendItemStyleSerial;
        self.pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
        UIView *legend = [self.pieChart getLegendWithMaxWidth:self.pieChart.frame.size.width];
        _legendView = legend;
        self.pieChart.frame = CGRectMake(10, 50, self.frame.size.width-20, self.frame.size.height-50-10-10-legend.height);
        [legend setFrame:CGRectMake(10, self.pieChart.mc_MaxY+10, legend.frame.size.width, legend.frame.size.height)];
        [self addSubview:legend];
    }else {
        //会员管理饼状图
        self.pieChart.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20);
    }
   
    [self.pieChart recompute];
    [self.pieChart strokeChart];
}

- (UIView *) getLegendView {
    if (_legendView) {
        return _legendView;
    }else {
        self.pieChart.legendStyle = PNLegendItemStyleSerial;
        self.pieChart.legendFont = [UIFont systemFontOfSize:12.0f];
        UIView *legend = [self.pieChart getLegendWithMaxWidth:self.pieChart.frame.size.width];
        return legend;
    }
}

#pragma mark - getter
- (PNPieChart *) pieChart {
    if (!_pieChart) {
        CGFloat y = 10;
        if (_bgView) {
            y = _bgView.mc_MaxY+10;
        }
        _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, y, self.frame.size.width-20, self.frame.size.height-y-10) items:_items];
        _pieChart.backgroundColor = [UIColor clearColor];
        _pieChart.descriptionTextColor = [UIColor blackColor];
        _pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        _pieChart.descriptionTextShadowColor = [UIColor clearColor];
        _pieChart.showAbsoluteValues = !self.isPercent;
        _pieChart.showOnlyValues = self.showOnlyValues;
        _pieChart.showNumberLabel = self.showNumberLabel;
        _pieChart.showPullLine = self.showPullLine;
        _pieChart.showLegendValues = self.showlegendValue;
    }
    return _pieChart;
}

- (UIView *) blankView {
    if (!_blankView) {
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, self.frame.size.width-20, self.frame.size.height-50-10)];
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

- (UIView *) bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        bgView.backgroundColor = chartViewContentBgColor();
        bgView.layer.borderColor = chartViewTitleBgBorderColor().CGColor;
        bgView.layer.borderWidth = 0.5;
        _bgView = bgView;
    }
    return _bgView;
}

- (UILabel *) titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = chartViewTitleTextColor();
        titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *) subTitleLabel {
    if (!_subTitleLabel) {
        UILabel *subTitle = [UILabel new];
        subTitle.textColor = chartViewTitleTextColor();
        subTitle.font = [UIFont systemFontOfSize:15];
        _subTitleLabel = subTitle;
    }
    return _subTitleLabel;
}

@end
