//
//  MathMethods.h
//  MC_PNChartView
//
//  Created by mc on 2017/11/21.
//  Copyright © 2017年 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathMethods : NSObject


/**
 求等差数列每项

 @param firstNumber 首项
 @param lastNumber  尾项
 @param counts      项数
 @return 通项数组
 */
NSArray<NSNumber *> * arithmeticProgression(float firstNumber, float lastNumber, unsigned int  counts);


/**
 数字数组转换成字符串数组

 @param numberArray 需要转换的数值数组
 @return 转换好的字符串数组
 */
NSArray<NSString *> * convertToStringArray(NSArray<NSNumber *> * numberArray);


/**
 数字转换成中单位（K，万，十万，百万，千万，亿）

 @param number 需要转换的数字
 @return 中文单位
 */
NSString * converNumberToChineseUnit(float number);

@end
