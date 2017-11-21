//
//  MathMethods.m
//  ZHDP
//
//  Created by mc on 2017/11/17.
//  Copyright © 2017年 合肥彼岸. All rights reserved.
//

#import "MathMethods.h"

@implementation MathMethods

NSArray<NSNumber *> * arithmeticProgression(float firstNumber, float lastNumber, unsigned int counts) {
    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:0];
    if (firstNumber == lastNumber) {
        [result addObject:@(firstNumber)];
        return result;
    }
    if (counts < 2) {
        [result addObject:@(firstNumber)];
        [result addObject:@(lastNumber)];
        return result;
    }
    //公差
    float commentDiff = (lastNumber-firstNumber)/(counts - 1);
    for (int i = 0; i<counts; i++) {
        float number = firstNumber + i* commentDiff;
        [result addObject:@(number)];
    }
    
    return result;
}

NSArray<NSString *> * convertToStringArray(NSArray<NSNumber *> * numberArray) {
    NSMutableArray<NSString *> *result = [NSMutableArray arrayWithCapacity:numberArray.count];
    for (NSNumber *number in numberArray) {
        [result addObject:converNumberToChineseUnit(number.floatValue)];
    }
    return result;
}

NSString * converNumberToChineseUnit(float number) {
    NSArray<NSString *> *array = [(@(number)).stringValue componentsSeparatedByString:@"."];
    NSString *intString = array.firstObject;
    NSUInteger intValue = ABS([intString integerValue]);

    NSString *result = nil;
    if (intValue < 1000) {
        result = [NSString stringWithFormat:@"%.0f",number];
    }else if (intValue > 1000 && intValue <= 9999) {
         //千(K) 1000
        result = [NSString stringWithFormat:@"%.1fK",intValue/1000.0];
    }else if (intValue > 10000 && intValue < 100000) {
        result = [NSString stringWithFormat:@"%.1f万",intValue/10000.0];
    }else if (intValue > 100000 && intValue < 1000000) {
        result = [NSString stringWithFormat:@"%.1f十万",intValue/100000.0];
    }else if (intValue > 1000000 && intValue < 10000000) {
        result = [NSString stringWithFormat:@"%.1f百万",intValue/1000000.0];
    }else if (intValue > 10000000 && intValue < 100000000) {
        result = [NSString stringWithFormat:@"%.1f千万",intValue/10000000.0];
    }else{
        result = [NSString stringWithFormat:@"%.1f亿",intValue/100000000.0];
    }
//    else if (intValue > 100000000 && intValue < 1000000000) {
    return result;
}


@end
