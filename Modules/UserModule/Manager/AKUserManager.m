//
//  AKUserManager.m
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserManager.h"

@implementation AKUserManager


#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKUserManager *_userManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userManager = [[AKUserManager alloc] init];
    });
    return _userManager;
}

/**
 用户是否已经登录
 
 @return 是否登录
 */
-(BOOL)isUserLogin
{
    return self.me == nil? NO:YES;
}


/**
 用户登录
 
 @param user UserModel信息
 @return 是否登录成功
 */
-(BOOL)userLogin:(UserModel*)user
{
    [[AKDataCenter sharedInstance] user_setUserInfo:user];
    
    [[AKRequestManager sharedInstance] updateHttpHeaderField:@"USER-UID" withValue:[user.uid stringValue]];
    [[AKRequestManager sharedInstance] updateHttpHeaderField:@"USER-TOKEN" withValue:user.token];

    self.me = [[AKDataCenter sharedInstance] user_getUserInfo:[user getKey]];
    if(self.me == nil){
        return NO;
    }
    return YES;
}


@end
