//
//  PNPieChart.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPieChartDataItem.h"
#import "PNGenericChart.h"
#import "PNChartDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
@interface PNPieChart : PNGenericChart
#else
@interface PNPieChart : PNGenericChart <CAAnimationDelegate>
#endif

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, readonly) NSArray	*items;

/** Default is 18-point Avenir Medium. */
@property (nonatomic) UIFont  *descriptionTextFont;

/** Default is white. */
@property (nonatomic) UIColor *descriptionTextColor;

/** Default is black, with an alpha of 0.4. */
@property (nonatomic) UIColor *descriptionTextShadowColor;

/** Default is CGSizeMake(0, 1). */
@property (nonatomic) CGSize   descriptionTextShadowOffset;

/** Default is 1.0. */
@property (nonatomic) NSTimeInterval duration;

/** Show only values, this is useful when legend is present */
@property (nonatomic) BOOL showOnlyValues;

/** Show absolute values not relative i.e. percentages */
@property (nonatomic) BOOL showAbsoluteValues;

/** 显示引线 */
@property (assign, nonatomic) BOOL showPullLine;

/** 显示数据label */
@property (assign, nonatomic) BOOL showNumberLabel;

/** Hide percentage labels less than cutoff value */
@property (nonatomic, assign) CGFloat labelPercentageCutoff;

/** Default YES. */
@property (nonatomic) BOOL shouldHighlightSectorOnTouch;

/** Current outer radius. Override recompute() to change this. **/
@property (nonatomic) CGFloat outerCircleRadius;

/** Current inner radius. Override recompute() to change this. **/
@property (nonatomic) CGFloat innerCircleRadius;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

/** Update chart items. Does not update chart itself. */
- (void)updateChartData:(NSArray *)data;

/** Multiple selection */
@property (nonatomic, assign) BOOL enableMultipleSelection;

/** show only tiles, not values or percentage */
@property (nonatomic) BOOL hideValues;

/** legendView show values */
@property (nonatomic) BOOL showLegendValues;

- (void)strokeChart;

- (void)recompute;

@end
