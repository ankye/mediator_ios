//
//  AKUserManager.h
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKUserManager : NSObject

@property (nonatomic,strong) AKUser* me;


+ (instancetype)sharedInstance;


-(AKUser*)getUserInfo:(NSString*)uid;


/**
 用户是否已经登录

 @return 是否登录
 */
-(BOOL)isUserLogin;

/**
 用户登录

 @param user AKUser信息
 @return 是否登录成功
 */
-(BOOL)userLogin:(AKUser*)user;


-(AKUser*)updateUserInfo:(AKUser*)user params:(NSDictionary*)params;


@end
