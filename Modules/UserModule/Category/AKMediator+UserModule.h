//
//  AKMediator+UserModule.h
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

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


-(AKUser*)user_getUserInfo:(NSString*)uid;


-(AKUser*)user_updateUserInfo:(NSMutableDictionary*)params;


@end
