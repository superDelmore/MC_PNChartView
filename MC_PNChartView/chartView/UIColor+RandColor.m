//
//  UIColor+RandColor.m
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import "UIColor+RandColor.h"

@implementation UIColor (RandColor)

UIColor* randColor(void) {
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return color;
}

UIColor* chartViewBackgroundColor(void) {
    return [UIColor colorWithWhite:0.98 alpha:1];
}

UIColor* chartViewTitleTextColor(void) {
    return [UIColor colorWithRed:0.20 green:0.20 blue:0.35 alpha:1.00];
}

UIColor* chartViewContentBgColor(void) {
    return [UIColor whiteColor];
}

UIColor* chartViewTitleBgBorderColor(void) {
    return [UIColor colorWithWhite:0.79 alpha:1];
}

//数据值的颜色
UIColor* chartViewContentItemColor(void) {
    return [UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.00];
}

@end
