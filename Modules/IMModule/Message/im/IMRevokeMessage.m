//
//  IMRevokeMessage.m
//  BanLiTV
//
//  Created by hk on 16/5/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRevokeMessage.h"

@implementation IMRevokeMessage

-(id)init
{
    if (self = [super init]) {
        self.messageType = MSG_REQUEST;
    }
    return self;
}

- (BOOL)request
{
    NSString* ReqID = [NSString stringWithFormat:@"%d",[self getRequestID]];
    NSArray * arr = @[@"im.revoke",@{@"to":self.toUid,@"index":self.revokeIndex},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}


- (BOOL)timeout
{
    return NO;
}
@end
