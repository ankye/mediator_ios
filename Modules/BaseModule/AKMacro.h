//
//  AKMacro.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

//单例宏定义

#define SHARED_METHOD_IMPLEMENTATION \
+ (instancetype)sharedInstance { \
    static id _Instance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _Instance = [self new]; \
    }); \
    return _Instance; \
}
