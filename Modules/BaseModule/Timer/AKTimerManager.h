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
 默认group创建定时器,延迟启动
 默认都可以在后台模式运行

 @param interval 定时器时间间隔
 @param delay 延迟启动
 @param uniqueID 定时器唯一标识
 @param repeatTimes 循环次数，-1表示一直执行
 @param action 定时器fire事件
 */
-(void)addTimerWithInterval:(NSInteger)interval withDelay:(double)delay withUniqueID:(NSString*)uniqueID withRepeatTimes:(NSInteger)repeatTimes withTimerFireAction:(timerFireAction)action;


/**
 默认group创建定时器,0延迟启动
 默认都可以在后台模式运行
 @param interval 定时器时间间隔
 @param uniqueID 定时器唯一标识
 @param repeatTimes 循环次数，-1表示一直执行
 @param action 定时器fire事件
 */
- (void) addTimerWithInterval:(NSInteger)interval withUniqueID:(NSString*)uniqueID withRepeatTimes:(NSInteger)repeatTimes withTimerFireAction:(timerFireAction)action;

/**
 参数方式创建定时器

 @param group 定时器组
 @param interval 定时器时间间隔
 @param delay 延迟启动
 @param uniqueID 定时器唯一标识
 @param canRunBackground 是否可以运行在后台模式
 @param repeatTimes 循环次数，-1表示一直执行
 @param action 定时器fire事件
 */
-(void)addTimerWithGroup:(NSString*)group withInterval:(NSInteger)interval withDelay:(double)delay withUniqueID:(NSString*)uniqueID withRunBackground:(BOOL)canRunBackground withRepeatTimes:(NSInteger)repeatTimes withTimerFireAction:(timerFireAction)action;


/**
 是否存在某个定时器,存在就返回该定时器
 
 @param group 定时器组
 @param uniqueID 唯一标识
 @return AKTimer or nil
 */
-(id<AKTimerProtocol>)isExistTimer:(NSString*)group withUniqueID:(NSString*)uniqueID;


/**
 添加定时器
 
 @param timer 定时器类
 */
- (void) addTimer:(id<AKTimerProtocol>)timer;

/**
 通过uniqueID移除某个Timer
 
 @param uniqueID 唯一标识
 */
- (void) removeTimerByID:(NSString*)uniqueID;

/**
 清理定义为group的定时器
 
 @param group 组名
 */
- (void) removeTimerByGroup:(NSString*)group;

@end
