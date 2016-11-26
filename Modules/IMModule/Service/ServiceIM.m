//
//  ServiceIM.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceIM.h"
#import "AKIMManager.h"
#import "AKIMManager+Message.h"

@implementation ServiceIM

/**
 请求im服务器列表，保存在IMManager里面
 */
-(NSNumber*)requestIMServerList:(NSDictionary*)params
{
    [[AKIMManager sharedInstance] requestIMServerList];
    return @(YES);
}

/**
 从WEB服务器请求IM访问token
 
 @param params 请求参数字典
 @return YES OR NO
 */
-(NSNumber*)requestIMToken:(NSDictionary*)params
{
    [[AKIMManager sharedInstance] requestIMToken:params[@"uid"] withUserToken:params[@"userToken"]];
    return @(YES);
}
@end
