//
//  UIColor+RandColor.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RandColor)

UIColor* randColor(void);

UIColor* chartViewBackgroundColor(void);

UIColor* chartViewTitleTextColor(void);

UIColor* chartViewContentBgColor(void);

UIColor* chartViewTitleBgBorderColor(void);

//数据值的颜色
UIColor* chartViewContentItemColor(void);


@end
