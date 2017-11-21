//
//  BarChartView.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatisticsDataModel;

@interface BarChartView : UIView

- (void) drawLineChartLineView:(NSArray<StatisticsDataModel *> *)datasource;

- (void) setChartTitle:(NSString *) titleString;

- (void) setChartSubTitle:(NSString *) subTitleString;

@end
