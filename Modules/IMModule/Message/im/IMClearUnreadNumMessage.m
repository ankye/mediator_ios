//
//  IMClearUnreadNumMessage.m
//  BanLiTV
//
//  Created by hk on 16/5/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMClearUnreadNumMessage.h"


@implementation IMClearUnreadNumMessage
- (id)init
{
    if (self = [super init]) {
        self.messageType = MSG_REQUEST;
    }
    return self;
}

- (BOOL)request
{
    NSString *Req_ID = [NSString stringWithFormat:@"%d", [self getRequestID]];
    NSArray *arr     = @[@"im.clear_unread_num",@{@"from":self.fromUid},Req_ID];
    NSString *str    = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance]sendData:str];
}

-(BOOL)timeout
{
    return NO;
}


@end
