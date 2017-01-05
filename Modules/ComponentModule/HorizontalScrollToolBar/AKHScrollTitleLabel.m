//
//  HSTB_DisplayTitleLabel.m
//  ZKHorizontalScrollToolBar
//
//  Created by 郑凯 on 2016/11/30.
//  Copyright © 2016年 tzktzk1. All rights reserved.
//

#import "AKHScrollTitleLabel.h"

@implementation AKHScrollTitleLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_fillColor set];
    
    rect.size.width = rect.size.width * _progress;
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end


