//
//  NSDate+Time.h
//  powerlife
//
//  Created by 陈行 on 16/4/20.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)

+ (NSString *)getCurrentTimeStr;
/**
 *  获取解析之后显示时间值
 *
 *  @param dateStr 1990-08-08 10:18:47
 *
 *  @return 解析之后显示的时间值
 */
+ (NSString *)getCustomTimeByCurrentTimeStrWithDateStr:(NSString *)dateStr;

+ (NSString *)getCustomTimeByCurrentTimeStrWithTimeInterval:(NSInteger)timeInterval;

+ (NSArray *)getCurrentTimeYearMonthDayHourMinuteSeconds;

@end
