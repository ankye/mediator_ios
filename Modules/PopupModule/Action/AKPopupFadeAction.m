//
//  AKPopupFadeAction.m
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKPopupFadeAction.h"

@implementation AKPopupFadeAction

- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context
{
    return context.action == STPopupControllerTransitioningActionPresent ? 0.25 : 0.2;
}

- (void)popupControllerAnimateTransition:(STPopupControllerTransitioningContext *)context completion:(void (^)())completion
{
    UIView *containerView = context.containerView;
    if (context.action == STPopupControllerTransitioningActionPresent) {
        containerView.alpha = 0;
        containerView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.alpha = 1;
            containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }
    else {
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.alpha = 0;
        } completion:^(BOOL finished) {
            containerView.alpha = 1;
            completion();
            if(self.onCompleted){
                self.onCompleted();
            }
        }];
    }
}

@end
