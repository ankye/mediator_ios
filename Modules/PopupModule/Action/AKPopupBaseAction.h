//
//  AKPopupBaseAction.h
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupModuleDefine.h"

typedef NS_ENUM(NSUInteger, AKPopupActionDirection) {
    AKPopupActionDirectionTop,
    AKPopupActionDirectionBottom,
    AKPopupActionDirectionLeft,
    AKPopupActionDirectionRight
};


@interface AKPopupBaseAction : NSObject <STPopupControllerTransitioning>

-(id)initWithDirection:(AKPopupActionDirection)direction;

@property (nonatomic,assign) AKPopupActionDirection direction;

@property (nonatomic,strong) CompleteFunc onCompleted;


@end
