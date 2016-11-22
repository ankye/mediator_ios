//
//  AKDataCenter+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter+UserModule.h"

#import "UserModel.h"

#define  KAKD_USERModel @"UserModel"


@implementation AKDataCenter (UserModule)

-(void)setUserInfo:(UserModel*)user
{
    [[AKDataCenter sharedInstance] updatePool:KAKD_USERModel withKey:[user getKey] andObject:(AKBaseModel*)user];
    
}
-(UserModel*)getUserInfo:(NSString*)uid
{
    UserModel* user = (UserModel*)[[AKDataCenter sharedInstance] getObjectFromPool:KAKD_USERModel withKey:uid];
    return user;
}

@end
