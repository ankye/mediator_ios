//
//  AKTimerProtocol.h
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AKTimerProtocol;

//定时器fire事件回调，传入定时器
typedef void(^timerFireAction)(id<AKTimerProtocol> timer);
#define KAK_TIMER_MAIN_GROUP @"mainGroup"

/**
 定时器协议，通过AKTimerManager管理的定时器类都要遵循此协议
 */
@protocol AKTimerProtocol <NSObject>

@property (nonatomic,copy)   NSString*          group;        //定时器组
@property (nonatomic,assign) NSInteger          interval;       //定时器时间间隔
@property (nonatomic,assign) double             delay;          //延迟启动
@property (nonatomic,copy) NSString*             uniqueID;       //定时器唯一标识
@property (nonatomic,assign) BOOL               canRunBackground;  //是否可以运行在后台模式
@property (nonatomic,copy)   timerFireAction    action;        //定时器fire事件
@property (nonatomic,assign) NSInteger          repeatTimes;    //循环次数，-1表示一直执行
//以下这些属性值管理器会计算，不用预设值
@property (nonatomic,assign) NSInteger          currentTimes;   //当前循环次数 ，默认从0开始
@property (nonatomic,assign) double             startTimestamp;  //定时器首次执行时间，计算当前时间+延迟时间+interval定时间隔
@property (nonatomic,assign) double             lastTimestamp;  //上一次执行时间,默认为0


@end


