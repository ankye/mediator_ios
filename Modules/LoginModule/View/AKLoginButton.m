//
//  AKLoginButton.m
//  Project
//
//  Created by ankye on 2016/11/17.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKLoginButton.h"

@implementation AKLoginButton

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    
    // 先创建一个btn，把外界对应的值传一下
    AKLoginButton *btn = [[AKLoginButton alloc] initWithFrame:frame];
    
    // 设置基本一些属性
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    if(highlightedImage){
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
//    btn.imageView.backgroundColor = [UIColor grayColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
 //   btn.titleLabel.backgroundColor = [UIColor blueColor];
    
    
    return btn;
}



// 重写UIButton的两个方法，此方法设置btn内部imageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.width;
    return CGRectMake(0, 0, imageW, imageH);
    
}


// 重写UIButton的两个方法，此方法设置btn内部titleLabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    // 根据btnType返回titleLabel不同的frame，具体怎么算的不需要解释
    CGFloat titleH = 24;
    CGFloat titleY = contentRect.size.height - titleH;
    CGFloat titleW = contentRect.size.width;
    
    return CGRectMake(0, titleY, titleW, titleH);
    
}

-(void)dealloc
{
    
}


@end
