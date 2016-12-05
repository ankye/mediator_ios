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

 @param userinfo 用户信息字典
 @return 是否登陆成功
 */
-(BOOL)user_loginSuccess:(NSDictionary*)userinfo;

/**
 判断是否有用户已经登陆

 @return 是否登陆成功
 */
-(BOOL)user_isUserLogin;


/**
 当前登陆用户信息

 @return 用户信息或者nil
 */
-(UserModel*)user_me;


-(UserModel*)user_getUserInfo:(NSNumber*)uid;


-(UserModel*)user_updateUserInfo:(NSMutableDictionary*)params;


@end
