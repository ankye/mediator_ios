//
//  AKResourceManager.h
//  Project
//
//  Created by ankye on 2016/12/19.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"

typedef id (^WeakReference)(void);

WeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id weakReferenceNonretainedObjectValue(WeakReference ref) {
    return ref ? ref() : nil;
}


@interface AKResourceManager : NSObject

SINGLETON_INTR(AKResourceManager)


-(void)removeUnusedResource;

/**
 获取当前OBJ引用计数

 @param obj obj
 @return 引用计数
 */
- (NSUInteger)retainCount:(NSObject*)obj ;


@end
