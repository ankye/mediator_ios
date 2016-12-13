//
//  AKMediator+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator+UserModule.h"

NSString * const kAKMUserModuleService = @"User";
NSString * const kAKMUserLoginSuccess = @"loginSuccess";
NSString * const kAKMUserIsLogin = @"isUserLogin";
NSString * const kAKMUserMe = @"getMe";
NSString * const kAKMUserGetInfo = @"getUserInfo";
NSString * const kAKMUserUpdateInfo = @"updateUserInfo";

@implementation AKMediator (UserModule)


/**
 登陆成功，更新用户信息
 
 @param user AKUser结构
 @return 是否登陆成功
 */
-(BOOL)user_loginSuccess:(AKUser*)user
{
    NSNumber* result = [self performService:kAKMUserModuleService action:kAKMUserLoginSuccess params:@{@"user":user} shouldCacheService:NO];
    return [result boolValue];
}

/**
 判断是否有用户已经登陆
 
 @return 是否登陆成功
 */
-(BOOL)user_isUserLogin
{
    NSNumber* result = [self performService:kAKMUserModuleService action:kAKMUserIsLogin params:nil shouldCacheService:NO];
    return [result boolValue];
}

/**
 当前登陆用户信息
 
 @return 用户信息或者nil
 */
-(AKUser*)user_me
{
    AKUser* me = [self performService:kAKMUserModuleService action:kAKMUserMe params:nil shouldCacheService:NO];
    return me;
}

/**
 当前用户信息
 
 @return 用户信息或者nil
 */
-(AKUser*)user_getUserInfo:(NSString*)uid
{
    AKUser* user = [self performService:kAKMUserModuleService action:kAKMUserGetInfo params:@{@"uid":uid} shouldCacheService:NO];
    return user;
}

-(AKUser*)user_updateUserInfo:(NSMutableDictionary*)params
{
    AKUser* user = [self performService:kAKMUserModuleService action:kAKMUserUpdateInfo params:params shouldCacheService:NO];
    return user;
}

@end
