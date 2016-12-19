//
//  AKDataCenter+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter+UserModule.h"
#import "AKDBManager+User.h"
#import "AKDBManager+UserDetail.h"
#import "AKUserDetail.h"
#import "AKUser.h"

#define  KAKD_USERModel @"AKUser"


@implementation AKDataCenter (UserModule)

-(void)user_setUserInfo:(AKUser*)user
{
    [AK_DATA_CENTER updatePool:KAKD_USERModel withKey:user.uid andObject:(AKBaseModel*)user];

    [AK_DB_MANAGER user_insertOrUpdate:user];
    if(user.detail){
        [AK_DB_MANAGER user_detail_insertOrUpdate:(AKUserDetail*)user.detail];
    }
    

}
-(AKUser*)user_getUserInfo:(NSString*)uid
{
    
    AKUser* user = (AKUser*)[AK_DATA_CENTER getObjectFromPool:KAKD_USERModel withKey:uid];
    if(user &&  [AppHelper isNullString: user.uid] ){
        
        AKUser* tempUser = [AK_DB_MANAGER user_queryByID:uid];
        if(tempUser){
            id<AKUserDetailProtocol> detail = [AK_DB_MANAGER user_detail_queryByID:uid];
            if(detail != nil && detail.uid != nil){
                [tempUser.detail fillData:detail];
            }
        }
        [user fillData:tempUser];
    }
    
    return user;
}

@end
