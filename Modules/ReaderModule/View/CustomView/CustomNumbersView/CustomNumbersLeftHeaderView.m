//
//  CustomNumbersLeftHeaderView.m
//  myTest
//
//  Created by 陈行 on 16/6/23.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomNumbersLeftHeaderView.h"

@implementation CustomNumbersLeftHeaderView

+ (instancetype)viewFromNib{
    NSString * nibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *backgroundView=[[UIView alloc]initWithFrame:self.bounds];
    backgroundView.backgroundColor=[UIColor colorWithWhite:0.922 alpha:1.000];
    self.backgroundView=backgroundView;
}

@end
