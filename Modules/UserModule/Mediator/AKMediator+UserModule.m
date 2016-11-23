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

@implementation AKMediator (UserModule)

-(BOOL)user_loginSuccess:(NSDictionary*)userinfo
{
   NSNumber* result = [self performService:kAKMUserModuleService action:kAKMUserLoginSuccess params:userinfo shouldCacheService:NO];
    return [result boolValue];
}

-(BOOL)user_isUserLogin
{
    NSNumber* result = [self performService:kAKMUserModuleService action:kAKMUserIsLogin params:nil shouldCacheService:NO];
    return [result boolValue];
}


@end
