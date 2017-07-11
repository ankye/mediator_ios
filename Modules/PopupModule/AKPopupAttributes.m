//
//  AKPopupAttributes.m
//  Project
//
//  Created by ankye sheng on 2017/7/10.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKPopupAttributes.h"

@implementation AKPopupAttributes

-(id)init
{
    self = [super init];
    
    _controller = nil;
    _showBG = NO;
    _showNav = NO;
    _onClick = nil;
    _onClose = nil;
    _onCompleted = nil;
    _style = STPopupStyleFormSheet;
    _actionType = AKPopupActionTypeBottom;
    _priority = AKPopupPriorityLow;
    _locked = NO;
    
    return self;
}

@end
