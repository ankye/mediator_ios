//
//  IMLiveMessage.m
//  BanLiTV
//
//  Created by zhout on 16/8/10.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMLivePingMessage.h"


@implementation IMLivePingMessage

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_NOTIFY;
    }
    return self;
}

-(BOOL)notify
{
    return YES;
}

-(BOOL)timeout
{
    return NO;
}

@end
