//
//  Popup.m
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import "CustomPopupItem.h"

@implementation CustomPopupItem


- (instancetype)initWithTitle:(NSString*)title msg:(NSString*)msg btnContent:(NSString*)btnContent
{
    self = [super init];
    if (self) {
        // 设置属性
        self.title = title;
        self.msgContent = msg;
        self.btnContet = btnContent;
    }
    return self;
}

@end
