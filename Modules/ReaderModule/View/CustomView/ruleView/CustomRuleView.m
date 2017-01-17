//
//  CustomRuleView.m
//  powerlife
//
//  Created by 陈行 on 16/4/21.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomRuleView.h"
#import "UIView+Category.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.width.height
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)

@implementation CustomRuleView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[UIColor colorWithWhite:0.847 alpha:1.000];
    self.height=SINGLE_LINE_WIDTH;
}

+ (instancetype)customRuleView{
    CustomRuleView * ruleView = [[CustomRuleView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SINGLE_LINE_WIDTH)];
    ruleView.backgroundColor=[UIColor colorWithWhite:0.910 alpha:1.000];
    return ruleView;
}

- (void)setIsHasShadow:(BOOL)isHasShadow{
    _isHasShadow=isHasShadow;
    if(isHasShadow){
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowColor = [UIColor colorWithRed:0.176 green:0.176 blue:0.329 alpha:0.000].CGColor;
    }
}

@end
