//
//  IMHeartBeatMessage.m
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMHeartBeatNotify.h"



@implementation IMHeartBeatNotify

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_NOTIFY;
    }
    return self;
}

-(BOOL)notify
{
   return [[AKIMManager sharedInstance] sendData:@"P"];
}


-(BOOL)timeout
{
    return NO;
}



@end
