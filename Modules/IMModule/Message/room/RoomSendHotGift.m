//
//  RoomSendHotGift.m
//  BanLiTV
//
//  Created by Luan Alex on 16/11/16.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "RoomSendHotGift.h"
#import "IMMessage.h"


@implementation RoomSendHotGift
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

    arr = @[@"room.send_hot_gift",@{@"room_uid":self.roomUid},ReqID];

    NSString * str = [arr mj_JSONString];

    return [[AKIMManager sharedInstance] sendData:str];
}

-(BOOL)response:(NSArray *)info
{
    if (info.count>1) {
        NSString * second = info[1];
        if ([AppHelper isNullString:second]) {
            self.responseBlock(nil);
        }
    }else{
        self.responseBlock(info[1]);
    }

    return YES;
}


-(BOOL)timeout
{
    self.responseBlock(IMTimeOut);
    return NO;
}

@end
