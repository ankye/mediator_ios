//
//  RootStandardTableCell.m
//  powerlife
//
//  Created by 陈行 on 16/6/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "RootStandardTableCell.h"

@implementation RootStandardTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text=@"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedView.hidden=NO;
        self.titleLabel.textColor=THEME_COLOR;
    }else{
        self.selectedView.hidden=YES;
        self.titleLabel.textColor=[UIColor colorWithWhite:0.255 alpha:1.000];
    }
}

@end
