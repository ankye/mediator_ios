//
//  IMRoomHostBroadcast.m
//  BanLiTV
//
//  Created by 栾有数 on 16/5/18.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomHostBroadcastMessage.h"


@implementation IMRoomHostBroadcastMessage
-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_REQUEST;
    }
    return self;
}

-(BOOL)request
{
//    NSString* ReqID = [NSString stringWithFormat:@"%d",[self getRequestID]];
//    if (self.hostBroadModel) {
//        
//    }
//    NSArray * arr = @[@"room.host_broadcast",[IMRoomHostBroadModel getLeaveOrJoin:self.hostBroadModel],ReqID];
//    NSString * str = [arr JSONString];
//    
//    return [[AKIMManager sharedInstance] sendData:str];
    return NO;
}

-(BOOL)response:(NSArray *)info
{
    return YES;
}


-(BOOL)timeout
{
    return NO;
}

@end




