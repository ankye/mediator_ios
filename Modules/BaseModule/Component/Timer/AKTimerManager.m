//
//  AKTimerManager.m
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKTimerManager.h"

@interface AKTimerManager ()


@property (nonatomic,strong)NSTimer*                timer;   //定时器设置
@property (nonatomic,strong)NSMutableArray*         timerObjects; //定时器管理容器
@property (nonatomic,strong)dispatch_queue_t        akTimerQueue; //定时器处理队列，保证同时只有一个线程处理定时器容器

@end


@implementation AKTimerManager

- (id) init
{
    self = [super init];
    if(self){
        _akTimerQueue = dispatch_queue_create("com.ak.timer.manager", 0);
        _timerObjects = [[NSMutableArray alloc] init];
    }
    return self;
}
/*
 * 单例创建
 */
+ (instancetype)sharedInstance
{
    static AKTimerManager *_timerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timerManager = [[AKTimerManager alloc] init];
    });
    return _timerManager;
}



/**
 开始定时器
 */
- (void) startTimer {
    if(_timer == nil){
        _timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(dispatchTimer)
                                       userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/**
 停止定时器
 */
- (void) stopTimer
{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}


/**
 添加定时器

 @param timer 定时器类
 */
- (void) addTimer:(id<AKTimerProtocol>)timer
{
    dispatch_async(_akTimerQueue, ^{
        //预设置，保证整个逻辑是正确的
        [timer setLastTimestamp:0];
        [timer setCurrentTimes:0];
        [timer setStartTimestamp:[timer delay] + [AppHelper getCurrentTimestamp] + [timer interval]];
        
        [_timerObjects addObject:timer];
    });
    
    
}

/**
 通过uniqueID移除某个Timer

 @param uniqueID double类型，唯一标识
 */
- (void) removeTimerByID:(double)uniqueID
{
    dispatch_async(_akTimerQueue, ^{
        
        int timerCount= (int)[_timerObjects count];
        
        for(int i= timerCount -1 ; i>=0 ; i--){
            id<AKTimerProtocol> timer = [_timerObjects objectAtIndex:i];
            if( [timer uniqueID] == uniqueID){
                [_timerObjects removeObjectAtIndex:i];
            }
        }
    });
}

/**
 清理定义为group的定时器

 @param group 组名
 */
- (void) removeTimerByGroup:(NSString*)group
{
    dispatch_async(_akTimerQueue, ^{
        
        int timerCount= (int)[_timerObjects count];
        
        for(int i= timerCount -1 ; i>=0 ; i--){
            id<AKTimerProtocol> timer = [_timerObjects objectAtIndex:i];
            if([[timer group] isEqualToString:group]){
                [_timerObjects objectAtIndex:i];
            }
        }
    });
    
}

/**
 清理回收
 */
-(void)dealloc{
    [self stopTimer];
    [self.timerObjects removeAllObjects];
    self.timerObjects = nil;
    self.akTimerQueue = nil;
    
}



/**
 定时器分发
 */
-(void) dispatchTimer
{
    dispatch_async(_akTimerQueue, ^{
        
        int timerCount= (int)[_timerObjects count];
        
        for(int i= timerCount -1 ; i>=0 ; i--){
            id<AKTimerProtocol> timer = [_timerObjects objectAtIndex:i];
            //可以触发就执行
            if([self timerCanFire:timer]){
                
                [timer setCurrentTimes: [timer currentTimes]+1];
                [timer setLastTimestamp:[AppHelper getCurrentTimestamp]];
                
                [timer action](timer);
            }
            //已经完成就移除
            if([self timerIsComplete:timer]){
                //do remove timer
               [_timerObjects objectAtIndex:i];
            }
            
        }
    });
    
}



/**
 检测定时器是否完成
 重复次数为-1表示永远不清理，一直有效,判断是否完成的条件是循环次数达到预设值
 @param timer 定时器
 @return YES OR NO
 */
-(BOOL)timerIsComplete:(id<AKTimerProtocol>)timer
{
    if([timer repeatTimes] == -1) { return NO; }
    if([timer currentTimes] >= [timer repeatTimes]){ //循环次数达到要求
        return YES;
    }
    
    return NO;
}

/**
 检测定时器是否可以触发
 触发标准为上一次执行时间和当前时间进行对比，超过时间间隔认为可以执行，第一次执行判断开始时间
 @param timer 定时器
 @return YES OR NO
 */
-(BOOL)timerCanFire:(id<AKTimerProtocol>)timer
{
    double currentTime = [AppHelper getCurrentTimestamp];
    //处理首次启动时间没到，直接返回
    if([timer startTimestamp] > currentTime){
        return NO;
    }else { //已经可以启动
        //第一次执行，肯定能执行，处理首次启动时间到了
        if([timer lastTimestamp] == 0){
            return YES;
        }else{
            //后面重复执行，通过最近执行时间戳+定时器时间间隔判断
            double newFireTimestamp = [timer lastTimestamp] + [timer interval];
            if(newFireTimestamp > currentTime){
                return NO;
            }else{
                return YES;
            }
            
        }
        
        
    }
    //应该不会执行到这里
    return NO;
}

@end


