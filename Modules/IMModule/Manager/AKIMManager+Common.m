//
//  IMManager+Common.m
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager+Common.h"
#import "IMHeartBeatNotify.h"
#import "AKIMManager+Message.h"

@implementation AKIMManager (Common)


-(void)heartbeat
{
    IMHeartBeatNotify* message = (IMHeartBeatNotify*)[self createMessage:@"heartbeat"];
    [self postMessage:message];
    
}

@end
