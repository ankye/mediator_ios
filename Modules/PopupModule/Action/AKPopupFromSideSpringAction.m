//
//  AKPopupFromTopSpringAction.m
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKPopupFromSideSpringAction.h"
#import <POP/POP.h>

@implementation AKPopupFromSideSpringAction

- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context
{
    return context.action == STPopupControllerTransitioningActionPresent ? 0.5 : 0.35;
    
}

-(CGPoint)getPushOffset:(UIView*)containerView
{
    switch (self.direction) {
        case AKPopupActionDirectionTop:
            return CGPointMake(containerView.superview.center.x, -(containerView.superview.bounds.size.height - containerView.frame.origin.y));
            break;
        case AKPopupActionDirectionBottom:
            return CGPointMake(containerView.superview.center.x, (containerView.superview.bounds.size.height + containerView.frame.origin.y));
            break;
        case AKPopupActionDirectionLeft:
            return CGPointMake(-(containerView.superview.bounds.size.width + containerView.frame.origin.x),containerView.superview.center.y);
            break;
        case AKPopupActionDirectionRight:
            return CGPointMake((containerView.superview.bounds.size.width + containerView.frame.size.width + containerView.frame.origin.x), containerView.superview.center.y);
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
            return CGPointMake(containerView.superview.center.x,  -( containerView.superview.bounds.size.height - containerView.frame.origin.y + containerView.frame.size.height));
            break;
        case AKPopupActionDirectionBottom:
            return CGPointMake(containerView.superview.center.x, containerView.superview.bounds.size.height + containerView.frame.origin.y + containerView.frame.size.height);
            break;
        case AKPopupActionDirectionLeft:
            return CGPointMake( -( containerView.superview.bounds.size.width + containerView.frame.origin.x + containerView.frame.size.width), containerView.superview.center.y);
            break;
        case AKPopupActionDirectionRight:
            return CGPointMake(containerView.superview.bounds.size.width + containerView.frame.origin.x + containerView.frame.size.width, containerView.superview.center.y);
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
        
        containerView.center = [self getPushOffset:containerView];
        
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:containerView.superview.center];
        // @(containerView.superview.center.x,containerView.superview.center.y);
        positionAnimation.springBounciness = 10;
        [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            completion();
        }];
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.springBounciness = 20;
        if(self.direction == AKPopupActionDirectionLeft || self.direction == AKPopupActionDirectionRight){
            scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.3, 1.1)];

        }else{
            scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
        }
        
        [containerView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        [containerView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
    }
    else {
        
 
        CGPoint point = [self getPopOffset:containerView];
        
        POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        offscreenAnimation.toValue = [NSValue valueWithCGPoint:point]; // @(point.y);
        [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            completion();
            if(self.onCompleted){
                self.onCompleted();
            }
        }];
        [containerView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
        
        
    }

}

@end
