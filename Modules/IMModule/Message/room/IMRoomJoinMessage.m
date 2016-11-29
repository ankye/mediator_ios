//
//  IMRoomJoinMessage.h
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomJoinMessage.h"



@implementation IMRoomJoinMessage

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
    NSArray * arr = @[@"room.join",@{@"room_uid":self.room_uid},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}

-(BOOL)response:(NSArray *)info
{
    if(self.complete){
        self.complete(YES,info);
    }
    return YES;
}


-(BOOL)timeout
{

    return NO;
}



@end
