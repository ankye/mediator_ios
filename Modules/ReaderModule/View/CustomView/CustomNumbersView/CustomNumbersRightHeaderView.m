//
//  CustomNumbersRightHeaderView.m
//  myTest
//
//  Created by 陈行 on 16/6/23.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomNumbersRightHeaderView.h"

@implementation CustomNumbersRightHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabelLeftCon.constant=0;
    self.titleLabelWidthCon.constant=[UIScreen mainScreen].bounds.size.width-100-13;
}

@end
