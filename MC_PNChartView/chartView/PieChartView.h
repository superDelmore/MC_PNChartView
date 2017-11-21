//
//  PieChartView.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class StatisticsDataModel;

@interface PieChartView : UIView
//在调用 drawPieChartView: 方法之前设置，否则无效
@property (assign, nonatomic) BOOL isPercent;

/** 显示引线 */
@property (assign, nonatomic) BOOL showPullLine;

@property (assign, nonatomic) BOOL showOnlyValues;

@property (assign, nonatomic) BOOL showNumberLabel;

@property (assign, nonatomic) BOOL showlegendValue;

@property (assign, nonatomic) BOOL showLegendView;

- (void) drawPieChartView:(NSArray *)datasource;

- (void) setChartTitle:(NSString *) titleString;

- (void) setChartSubTitle:(NSString *) subTitleString;

- (UIView *) getLegendView;
@end
