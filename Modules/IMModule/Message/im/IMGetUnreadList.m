//
//  IMGetUnreadList.m
//  BanLiTV
//
//  Created by hk on 16/5/20.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMGetUnreadList.h"


@implementation IMGetUnreadList
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
    NSArray * arr = @[@"im.get_unread_list",@"",ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}




-(BOOL)timeout
{
    return NO;
}
@end
