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

/**
 signal install, binding with signal and attribute

 @param _signal signal name
 @param _attr attribute name
 @return get method
 */
#define GET_SIGNAL_INSTALL(_signal,_attr) \
@dynamic _attr; \
- ( UBSignal< _signal > *)_attr { \
UBSignal< _signal >* signalObj = objc_getAssociatedObject(self, @selector(_attr)); \
if(!signalObj){ \
signalObj = (UBSignal< _signal > *)[[UBSignal alloc] initWithProtocol:@protocol(_signal)]; \
objc_setAssociatedObject(self, @selector(_attr), signalObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
return signalObj; \
} \



#define AK_SIGNAL_MANAGER [AKSignalManager sharedInstance]

@interface AKSignalManager : NSObject

SINGLETON_INTR(AKSignalManager)


@end
