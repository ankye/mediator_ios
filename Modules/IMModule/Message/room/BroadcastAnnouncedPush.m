//
//  BroadcastAnnounced.m
//  BanLiTV
//
//  Created by Luan Alex on 16/7/12.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "BroadcastAnnouncedPush.h"

@implementation BroadcastAnnouncedPush
-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}



-(BOOL)push:(NSArray *)info
{

    /**
     *  飞屏全服通知协议
     */
    
    
    return YES;
}

@end
