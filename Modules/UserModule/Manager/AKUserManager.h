//
//  AKUserManager.h
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AKUserManager : NSObject

@property (nonatomic,strong) UserModel* me;


+ (instancetype)sharedInstance;


-(UserModel*)getUserInfo:(NSNumber*)uid;


/**
 用户是否已经登录

 @return 是否登录
 */
-(BOOL)isUserLogin;

/**
 用户登录

 @param user UserModel信息
 @return 是否登录成功
 */
-(BOOL)userLogin:(UserModel*)user;


-(UserModel*)updateUserInfo:(UserModel*)user params:(NSDictionary*)params;


@end
