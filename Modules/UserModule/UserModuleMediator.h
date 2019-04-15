//
//  UserModuleMediator.h
//  Project
//
//  Created by ankye sheng on 2017/7/12.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKUser.h"

#import "AKDataCenter+UserModule.h"
#import "GVUserDefaults+UserModule.h"
#import "AKSignalManager+UserModule.h"

@interface AKMediator (UserModule)


/**
 登陆成功，更新用户信息
 
 @param user AKUser
 @return 是否登陆成功
 */
-(BOOL)user_loginSuccess:(AKUser*)user;

/**
 判断是否有用户已经登陆
 
 @return 是否登陆成功
 */
-(BOOL)user_isUserLogin;


/**
 当前登陆用户信息
 
 @return 用户信息或者nil
 */
-(AKUser*)user_me;

/**
 获取单个用户信息
 */
-(AKUser*)user_getUserInfo:(NSString*)uid;

/**
 更新用户信息
 */
-(AKUser*)user_updateUserInfo:(NSMutableDictionary*)params;


@end

