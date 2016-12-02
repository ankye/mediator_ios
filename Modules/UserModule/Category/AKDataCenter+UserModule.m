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

-(void)user_setUserInfo:(UserModel*)user
{
    [AK_DATA_CENTER updatePool:KAKD_USERModel withKey:[user getKey] andObject:(AKBaseModel*)user];
    [GVUserDefaults standardUserDefaults].uid = user.uid;
    
    if(![AK_DB_MANAGER isExistUser:[user.uid integerValue]]){
        
        [AK_DB_MANAGER insertUser:user];
    }else{
        [AK_DB_MANAGER updateUser:user];
    }
    

}
-(UserModel*)user_getUserInfo:(NSString*)uid
{
    
    UserModel* user = (UserModel*)[AK_DATA_CENTER getObjectFromPool:KAKD_USERModel withKey:uid];
    if(user.pk_cid <= 0){
        UserModel *tempUser = [AK_DB_MANAGER queryUserByUid:[uid integerValue]];
        if(tempUser){
            [user fillData:tempUser];
        }
    }
    return user;
}

@end
