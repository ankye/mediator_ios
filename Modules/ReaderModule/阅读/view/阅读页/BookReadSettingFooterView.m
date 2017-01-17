//
//  BookReadSettingFooterView.m
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadSettingFooterView.h"

@implementation BookReadSettingFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.bookMarkBtn.hidden = YES;
    
    self.settingBtn.hidden = YES;
}

@end
