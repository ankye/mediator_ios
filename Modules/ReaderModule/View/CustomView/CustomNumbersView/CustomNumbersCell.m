//
//  CustomNumbersCell.m
//  myTest
//
//  Created by 陈行 on 16/6/22.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomNumbersCell.h"

@implementation CustomNumbersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor=[UIColor colorWithWhite:0.847 alpha:1.000].CGColor;
    self.layer.borderWidth=SINGLE_LINE_WIDTH;
}

@end
