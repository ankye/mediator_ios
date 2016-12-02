//
//  AKSignalManager.h
//  Project
//
//  Created by ankye on 2016/12/1.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModuleDefine.h"
#import "NSObject+CategoryWithProperty.h"

#import <UberSignals/UberSignals.h>

#define AK_SIGNAL_MANAGER [AKSignalManager sharedInstance]

@interface AKSignalManager : NSObject

SINGLETON_INTR(AKSignalManager)


@end
