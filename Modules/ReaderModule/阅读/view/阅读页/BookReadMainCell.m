//
//  BookReadMainCell.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadMainCell.h"
#import "UIView+Category.h"
#import "NSDate+Time.h"

@implementation BookReadMainCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.textLabel.font= [UIFont systemFontOfSize:READ_FONT_NUM];
    
    [self.reloadBtn layoutCornerRadiusWithCornerRadius:4];
    
}

- (void)setBookChapter:(BookChapter *)bookChapter{
    _bookChapter = bookChapter;
    
    //设置可以使用电池电量
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel==-1?0:[UIDevice currentDevice].batteryLevel;
    self.actualBatteryWidthCon.constant = (15.f/100)*100*batteryLevel;
    
    NSArray * dateArray = [NSDate getCurrentTimeYearMonthDayHourMinuteSeconds];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",dateArray[3],dateArray[4]];
    
}

@end
