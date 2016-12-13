//
//  ServiceUser.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceUser.h"
#import "AKUserManager.h"

@implementation ServiceUser

/**
 用户是否已经登录
 
 @return 是否登录
 */
-(NSNumber*)isUserLogin:(NSDictionary *)params
{
    BOOL result=  [[AKUserManager sharedInstance] isUserLogin];
    return @(result);
}
//登陆成功处理逻辑
-(NSNumber*)loginSuccess:(NSDictionary *)params
{
    AKUser* user = params[@"user"];
    if(user){
        [[AKUserManager sharedInstance] userLogin:user];
    }
    return @(YES);
}

/**
 获取登陆用户信息
 
 @return AKUser
 */
-(AKUser*)getMe:(NSDictionary *)params
{
    return [AKUserManager sharedInstance].me;
}


/**
 获取用户信息
 
 @param params 参数
 @return 返回用户信息
 */
-(AKUser*)getUserInfo:(NSDictionary*)params
{
    
    return [[AKUserManager sharedInstance] getUserInfo:params[@"uid"]];
}


-(AKUser*)updateUserInfo:(NSDictionary*)params
{
    AKUser* user = [[AKUserManager sharedInstance] getUserInfo:params[@"uid"]];
    
    return [[AKUserManager sharedInstance] updateUserInfo:user params:params];
    
}

@end
