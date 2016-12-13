//
//  NSDate+TLChat.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/3.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "NSDate+TLChat.h"

@implementation NSDate (TLChat)

- (NSString *)chatTimeInfo
{
    if ([self isToday]) {       // 今天
        return self.jk_hmsFormat;
    }
    else if ([self isYesterday]) {      // 昨天
        return [NSString stringWithFormat:@"昨天 %@", self.jk_formatYMD];
    }
    else if ([self jk_isThisWeek]){        // 本周
        return [NSString stringWithFormat:@"%@ %@", self.jk_dayFromWeekday, self.jk_formatYMD];
    }
    else {
        return [NSString stringWithFormat:@"%@ %@", self.jk_formatYMD, self.jk_hmsFormat];
    }
}

- (NSString *)conversaionTimeInfo
{
    if ([self isToday]) {       // 今天
        return self.jk_hmsFormat;
    }
    else if ([self isYesterday]) {      // 昨天
        return @"昨天";
    }
    else if ([self jk_isThisWeek]){        // 本周
        return self.jk_dayFromWeekday;
    }
    else {
        return [self jk_stringWithFormat:@"/"];
    }
}

- (NSString *)chatFileTimeInfo
{
    return [self jk_timeInfo];
}

@end
