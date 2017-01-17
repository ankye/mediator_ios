//
//  UIView+Category.m
//  powerlife
//
//  Created by 陈行 on 16/6/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

+ (instancetype)viewFromNib{
    NSString * nibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] firstObject];
}

- (void)layoutCornerRadiusWithCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=cornerRadius;
}


- (void)releaseView{
    [self releaseView:self];
}

- (void)releaseView:(UIView *)view{
    static NSInteger i=0;
    if(view.subviews.count==0){
        //        NSLog(@"%ld -->%@",(long)i,NSStringFromClass([view class]));
        if ([view isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)view).image=nil;
        }
        [view removeFromSuperview];
        i++;
        return;
    }
    for (UIView * subView in view.subviews) {
        [self releaseView:subView];
    }
}

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x=x;
    self.frame=rect;
}
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y=y;
    self.frame=rect;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width=width;
    self.frame=rect;
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height=height;
    self.frame=rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}



@end
