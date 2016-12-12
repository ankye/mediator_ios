//
//  AKDataCenter+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter+UserModule.h"

#import "AKUser.h"

#define  KAKD_USERModel @"UserModel"


@implementation AKDataCenter (UserModule)

-(void)user_setUserInfo:(AKUser*)user
{
    [AK_DATA_CENTER updatePool:KAKD_USERModel withKey:user.uid andObject:(AKBaseModel*)user];
    
    
    [AK_DB_MANAGER insertOrUpdateUser:user];
    
    

}
-(AKUser*)user_getUserInfo:(NSString*)uid
{
    
    AKUser* user = (AKUser*)[AK_DATA_CENTER getObjectFromPool:KAKD_USERModel withKey:uid];
    if(user){
        
        id<AKUserProtocol> tempUser = [AK_DB_MANAGER queryUserByID:uid];
        if(tempUser){
            [user fillData:tempUser];
        }
    }
    
    return user;
}

@end
