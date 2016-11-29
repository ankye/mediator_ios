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
    [[AKDataCenter sharedInstance] updatePool:KAKD_USERModel withKey:[user getKey] andObject:(AKBaseModel*)user];
    [GVUserDefaults standardUserDefaults].uid = user.uid;
    
    if(![[AKDBManager sharedInstance] isExistUser:[user.uid integerValue]]){
        
        [[AKDBManager sharedInstance] insertUser:user];
    }else{
        [[AKDBManager sharedInstance] updateUser:user];
    }
    

}
-(UserModel*)user_getUserInfo:(NSString*)uid
{
    
    UserModel* user = (UserModel*)[[AKDataCenter sharedInstance] getObjectFromPool:KAKD_USERModel withKey:uid];
    if(user.pk_cid <= 0){
        UserModel *tempUser = [[AKDBManager sharedInstance] queryUserByUid:[uid integerValue]];
        if(tempUser){
            [user fillData:tempUser];
        }
    }
    return user;
}

@end
