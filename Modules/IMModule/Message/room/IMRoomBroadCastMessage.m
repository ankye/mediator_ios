//
//  IMRoomBroadCastMessage.m
//  BanLiTV
//
//  Created by ZT on 16/5/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomBroadCastMessage.h"


@implementation IMRoomBroadCastMessage

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_REQUEST;
    }
    return self;
}

-(BOOL)request
{
    NSString* ReqID = [NSString stringWithFormat:@"%d",[self getRequestID]];
    NSArray * arr;
    
    arr = @[@"room.broadcast",self.data,ReqID];
    
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
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
