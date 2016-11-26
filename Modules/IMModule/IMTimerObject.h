//
//  IMTimerObject.h
//  BanLiTV
//
//  Created by ankye on 16/4/4.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum IMTimerType : NSInteger {
    IM_TIMER_TYPE_CONNECT = 1,
    IM_TIMER_TYPE_REQUEST = 2,
    IM_TIMER_TYPE_HEARTBEAT = 3
} IMTimerType;

@interface IMTimerObject : NSObject
{
    
    
    
}

@property (nonatomic,assign) IMTimerType     type;       //定时器类型
@property (nonatomic,assign) int             interval;   //时间间隔
@property (nonatomic,assign) double          startInterval;  //开始时间
@property (nonatomic,assign) int             requestID;     //请求id,心跳默认为空
@property (nonatomic,assign) int             times;         //循环次数，-1表示
//@property (nonatomic,assign) int             currentTimes;  //当前循环次数

@end
