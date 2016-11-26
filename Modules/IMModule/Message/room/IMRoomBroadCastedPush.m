//
//  IMRoomBroadCastePush.m
//  BanLiTV
//
//  Created by ZT on 16/5/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomBroadCastedPush.h"

@implementation IMRoomBroadCastedPush

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
