//
//  NSDate+Time.m
//  powerlife
//
//  Created by 陈行 on 16/4/20.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)

+ (NSString *)getCustomTimeByCurrentTimeStrWithDateStr:(NSString *)dateStr{
    NSString * time;
    NSArray * array = [dateStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
    
    NSInteger year = [array[0] integerValue];
    NSInteger month = [array[1] integerValue];
    NSInteger day = [array[2] integerValue];
    NSInteger hour = [array[3] integerValue];
    NSInteger minute = [array[4] integerValue];
    NSInteger millSecond = [array[5] integerValue];
    
    NSArray * currentTimeArray = [NSDate getCurrentTimeYearMonthDayHourMinuteSeconds];
    
    NSInteger currentyear = [currentTimeArray[0] integerValue];
    NSInteger currentmonth = [currentTimeArray[1] integerValue];
    NSInteger currentday = [currentTimeArray[2] integerValue];
    NSInteger currenthour = [currentTimeArray[3] integerValue];
    NSInteger currentminute = [currentTimeArray[4] integerValue];
    NSInteger currentmillSecond = [currentTimeArray[5] integerValue];
    
    if(year==currentyear){
        if(month==currentmonth){
            if(day==currentday){
                if(hour==currenthour){
                    if(minute==currentminute){
                        if(millSecond==currentmillSecond){
                            time = @"刚刚发布";
                        }else{
                            time = [NSString stringWithFormat:@"%ld秒前",currentmillSecond-millSecond];
                        }
                    }else if(currentminute-minute==1){
                        if(currentmillSecond-millSecond>0){
                            time = @"1分钟前";
                        }else{
                            time = [NSString stringWithFormat:@"%ld秒前",currentmillSecond+(60-millSecond)];
                        }
                    }else{
                        time = [NSString stringWithFormat:@"%ld分钟前",currentminute-minute-1];
                    }
                }else if(currenthour-hour==1){
                    if(currentminute-minute>0){
                        time = @"1小时前";
                    }else{
                        time = [NSString stringWithFormat:@"%ld分钟前",currentminute+(60-minute)];
                    }
                }else{
                    time = [NSString stringWithFormat:@"%ld小时前",currenthour-hour-1];
                }
            }else if(currentday-day==1){
                if (currenthour-hour>0) {
                    time = @"昨天";
                }else{
                    time = [NSString stringWithFormat:@"%ld小时前",currenthour+(24-hour)];
                }
            }else if (currentday-day==2){
                time = @"1天前";
            }else if (currentday-day==3){
                time = @"2天前";
            }else{
                time = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
            }
        }else{
            time = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        }
    }else{
        time = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    }
    return time;
}

+ (NSString *)getCustomTimeByCurrentTimeStrWithTimeInterval:(NSInteger)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString * res = [[date description] substringToIndex:[date description].length-6];
    return [self getCustomTimeByCurrentTimeStrWithDateStr:res];
}

+ (NSArray *)getCurrentTimeYearMonthDayHourMinuteSeconds{
    NSString * time = [self getCurrentTimeStr];
    return [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
}

/**
 *  获取当前时间的字符串
 *
 *  @return
 */
+ (NSString *)getCurrentTimeStr{
    NSInteger time = [self getCurrentTimeMillisecond];
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSString * res = [date description];
    return [res substringToIndex:res.length-6];
}

/**
 *  获取当前时间的毫秒数
 *
 *  @return
 */
+ (NSInteger)getCurrentTimeMillisecond{
    NSDate * date=[NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    return [[date dateByAddingTimeInterval:time] timeIntervalSince1970];
}

@end
