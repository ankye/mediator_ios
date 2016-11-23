//
//  AKTimerManager.h
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKTimerProtocol.h"

/**
 定时器管理类，精度为1s
 */
@interface AKTimerManager : NSObject

+ (instancetype)sharedInstance;


/**
 启动定时器
 */
- (void) startTimer;


/**
 停止定时器
 */
- (void) stopTimer;


/**
 添加定时器
 
 @param timer 定时器类
 */
- (void) addTimer:(id<AKTimerProtocol>)timer;

/**
 通过uniqueID移除某个Timer
 
 @param uniqueID double类型，唯一标识
 */
- (void) removeTimerByID:(double)uniqueID;

/**
 清理定义为group的定时器
 
 @param group 组名
 */
- (void) removeTimerByGroup:(NSString*)group;

@end
