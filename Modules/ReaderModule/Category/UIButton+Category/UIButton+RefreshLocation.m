//
//  UIButton+RefreshLocation.m
//  电动生活
//
//  Created by 陈行 on 15-12-23.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "UIButton+RefreshLocation.h"

@implementation UIButton (RefreshLocation)

- (void)refreshTopBottom{
    CGFloat btnH=self.frame.size.height;
    CGFloat btnW=self.frame.size.width;
    
    CGFloat ivX=self.imageView.frame.origin.x;
    CGFloat ivY=self.imageView.frame.origin.y;
    CGFloat ivW=self.imageView.frame.size.width;
    
    CGFloat titX=self.titleLabel.frame.origin.x;
    CGFloat titY=self.titleLabel.frame.origin.y;
    CGFloat titW=self.titleLabel.frame.size.width;
    CGFloat titH=self.titleLabel.frame.size.height;
    
    //top
    CGFloat t1=-ivY;
    CGFloat l1=btnW*0.5-(ivX+ivW*0.5);
    CGFloat b1=-t1;
    CGFloat r1=-l1;
    self.imageEdgeInsets=UIEdgeInsetsMake(t1,l1,b1,r1);
    
    CGFloat t2=btnH-titY-titH;
    CGFloat l2=btnW*0.5-(titX+titW*0.5);
    CGFloat b2=-t2;
    CGFloat r2=-l2;
    
    self.titleEdgeInsets=UIEdgeInsetsMake(t2,l2,b2,r2);
}

- (void)refreshRightLeft{
    CGFloat ivW=self.imageView.frame.size.width;
    CGFloat titW=self.titleLabel.frame.size.width;
    
    CGFloat t1=0;
    CGFloat l1=titW;
    CGFloat b1=-t1;
    CGFloat r1=-l1;
    self.imageEdgeInsets=UIEdgeInsetsMake(t1,l1,b1,r1);
    
    CGFloat t2=0;
    CGFloat l2=-ivW;
    CGFloat b2=-t2;
    CGFloat r2=-l2;
    self.titleEdgeInsets=UIEdgeInsetsMake(t2,l2,b2,r2);
}

- (void)refreshBottomTop{
    
}

- (void)refreshImageViewWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right{
    UIEdgeInsets edg=self.imageEdgeInsets;
    edg.top+=top;
    edg.bottom+=bottom;
    edg.left+=left;
    edg.right+=right;
    self.imageEdgeInsets=edg;
}

- (void)refreshTitleLabelWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right{
    UIEdgeInsets edg=self.titleEdgeInsets;
    edg.top+=top;
    edg.bottom+=bottom;
    edg.left+=left;
    edg.right+=right;
    self.titleEdgeInsets=edg;
}

@end
