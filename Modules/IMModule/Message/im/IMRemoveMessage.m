//
//  IMRemoveMessage.m
//  BanLiTV
//
//  Created by hk on 16/6/23.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRemoveMessage.h"


@implementation IMRemoveMessage

-(id)init
{
    if (self = [super init]) {
        self.messageType = MSG_REQUEST;
    }
    return self;
}

- (BOOL)request
{
//    NSString *requestId = [NSString stringWithFormat:@"%d",[self getRequestID]];
//    NSArray *requestAry = @[REQ_IM_REMOVE,@{@"from":self.uid,@"startIndex":self.startIndex,@"endIndex":self.endIndex},requestId];
//    NSString *requestStr = [requestAry mj_JSONString];
//    return [[AKIMManager sharedInstance]sendData:requestStr];
    return YES;
}

- (BOOL)response:(NSArray *)info
{
        return YES;
}

- (BOOL)timeout
{
    return NO;
}
@end
