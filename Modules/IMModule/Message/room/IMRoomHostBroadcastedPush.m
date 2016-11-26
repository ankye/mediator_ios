//
//  IMRoomHostBroadcastedPush.m
//  BanLiTV
//
//  Created by 栾有数 on 16/5/18.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomHostBroadcastedPush.h"
#import "IMRoomHostBroadcastMessage.h"
@implementation IMRoomHostBroadcastedPush


-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
    
    return YES;
}


@end
