//
//  RootNavButton.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "RootNavButton.h"

@implementation RootNavButton

+ (instancetype)buttonWithTitle:(NSString *)title{
    RootNavButton * rootNavBtn = [RootNavButton buttonWithType:UIButtonTypeCustom];
    
    CGSize size = CGSizeMake(MAXFLOAT, 44);
    
    size = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    rootNavBtn.frame = CGRectMake(0, 0, size.width+20, 44);
    
    [rootNavBtn setTitle:title forState:UIControlStateNormal];
    
    [rootNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    rootNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    return rootNavBtn;
}

@end
