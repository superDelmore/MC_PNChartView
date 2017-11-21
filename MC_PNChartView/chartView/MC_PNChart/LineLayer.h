//
//  LineLayer.h
//  PNChartDemo
//
//  Created by mc on 2017/11/9.
//  Copyright © 2017年 kevinzhow. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class PNPieChartDataItem;

@interface LineLayer : CALayer

@property (strong, nonatomic) NSArray<PNPieChartDataItem *> *dataItems;

@property (strong, nonatomic) NSArray *angels;

@property (assign, nonatomic) CGFloat cirY;

@property (assign, nonatomic) CGFloat cirX;

@property (assign, nonatomic) CGFloat radiu;

@property (strong, nonatomic) UIFont *descriptionTextFont;

@property (assign, nonatomic) BOOL showAbsoluteValues;

@property (assign, nonatomic) BOOL showOnlyValues;

@property (assign, nonatomic) BOOL hideValues;


@end
