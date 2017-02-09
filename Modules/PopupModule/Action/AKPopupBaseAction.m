//
//  AKPopupBaseAction.m
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKPopupBaseAction.h"

@implementation AKPopupBaseAction

-(id)initWithDirection:(AKPopupActionDirection)direction
{
    self = [super init];
    if(self){
        self.direction = direction;
    }
    return self;
}

- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context
{
    return context.action == STPopupControllerTransitioningActionPresent ? 0.5 : 0.35;
    
}
- (void)popupControllerAnimateTransition:(STPopupControllerTransitioningContext *)context completion:(void(^)())completion
{
    
}

-(void)dealloc
{
    self.onCompleted = nil;
}

@end
