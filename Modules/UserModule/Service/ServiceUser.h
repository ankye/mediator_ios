//
//  ServiceUser.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceUser : NSObject

/**
 用户是否已经登录
 
 @return 是否登录
 */
-(NSNumber*)isUserLogin:(NSDictionary *)params;


//登陆成功处理逻辑
-(NSNumber*)loginSuccess:(NSDictionary *)params;


/**
 获取登陆用户信息

 @return AKUser
 */
-(AKUser*)getMe:(NSDictionary *)params;


/**
 获取用户信息

 @param params 参数
 @return 返回用户信息
 */
-(AKUser*)getUserInfo:(NSDictionary*)params;


-(AKUser*)updateUserInfo:(NSDictionary*)params;

@end
