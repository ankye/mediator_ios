//
//  UIView+Animation.m
//  HaoYi
//
//  Created by 浩光 谢 on 16/8/18.
//  Copyright © 2016年 浩光 谢. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
///旋转动画
-(void)startRotateAnimating
{
    
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = HUGE_VALF;
    
    rotate.duration = 0.25;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)stopLayerAnimating
{
    [self.layer removeAllAnimations];
}
@end
