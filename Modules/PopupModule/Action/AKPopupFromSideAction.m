//
//  AKPopupFromSideAction.m
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKPopupFromSideAction.h"

@implementation AKPopupFromSideAction

- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context
{
    return context.action == STPopupControllerTransitioningActionPresent ? 0.35 : 0.3;

}

-(CGPoint)getPushOffset:(UIView*)containerView
{
    switch (self.direction) {
        case AKPopupActionDirectionTop:
            return CGPointMake(0,  -(containerView.superview.bounds.size.height - containerView.frame.origin.y));
            break;
        case AKPopupActionDirectionBottom:
            return CGPointMake(0, containerView.superview.bounds.size.height - containerView.frame.origin.y);
            break;
        case AKPopupActionDirectionLeft:
            return CGPointMake( -(containerView.superview.bounds.size.width - containerView.frame.origin.x), 0);
            break;
        case AKPopupActionDirectionRight:
            return CGPointMake(containerView.superview.bounds.size.width - containerView.frame.origin.x, 0);
            break;
        default:
            return CGPointMake(0, 0);
            break;
    }
}

-(CGPoint)getPopOffset:(UIView*)containerView
{
    switch (self.direction) {
        case AKPopupActionDirectionTop:
            return CGPointMake(0,  -( containerView.superview.bounds.size.height - containerView.frame.origin.y + containerView.frame.size.height));
            break;
        case AKPopupActionDirectionBottom:
            return CGPointMake(0, containerView.superview.bounds.size.height - containerView.frame.origin.y + containerView.frame.size.height);
            break;
        case AKPopupActionDirectionLeft:
            return CGPointMake(-( containerView.superview.bounds.size.width - containerView.frame.origin.x + containerView.frame.size.height), 0);
            break;
        case AKPopupActionDirectionRight:
           return CGPointMake(containerView.superview.bounds.size.width - containerView.frame.origin.x + containerView.frame.size.width, 0);
            break;
        default:
            return CGPointMake(0, 0);
            break;
    }
}

- (void)popupControllerAnimateTransition:(STPopupControllerTransitioningContext *)context completion:(void(^)())completion
{
    UIView *containerView = context.containerView;
    if (context.action == STPopupControllerTransitioningActionPresent) {
        CGPoint point = [self getPushOffset:containerView];
        containerView.transform = CGAffineTransformMakeTranslation(point.x,point.y);
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            context.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
          
        }];
    }
    else {
        
        CGAffineTransform lastTransform = containerView.transform;
        containerView.transform = CGAffineTransformIdentity;
        containerView.transform = lastTransform;
     
        CGPoint point = [self getPopOffset:containerView];
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.transform = CGAffineTransformMakeTranslation(point.x,point.y);
        } completion:^(BOOL finished) {
            containerView.transform = CGAffineTransformIdentity;
            completion();
            if(self.onCompleted){
                self.onCompleted();
            }
        }];
    }
    

}
@end
