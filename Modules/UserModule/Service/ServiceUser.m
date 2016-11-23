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
-(NSNumber*)isUserLogin
{
    BOOL result=  [[AKUserManager sharedInstance] isUserLogin];
    return @(result);
}
//登陆成功处理逻辑
-(NSNumber*)loginSuccess:(NSDictionary *)params
{
    
    UserModel* user = [UserModel modelWithDictionary:params];
    [[AKUserManager sharedInstance] userLogin:user];
    
    return @(YES);
}


@end
