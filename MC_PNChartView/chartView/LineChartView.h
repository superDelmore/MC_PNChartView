//
//  LineChartView.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LineChartView : UIView

@property (assign, nonatomic) NSInteger statisticsType;

- (void) drawLineChartLineView:(NSArray<NSDictionary *> *)datasource;

- (void) setChartTitle:(NSString *) titleString;

- (void) setChartSubTitle:(NSString *) subTitleString;

@end
