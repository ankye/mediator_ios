//
//  AKDataCenter+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "UserModuleDefine.h"
#import "AKDataCenter+UserModule.h"
#import "AKUserDetail.h"
#import "AKUser.h"



@implementation AKDataCenter (UserModule)

-(void)user_setUserInfo:(AKUser*)user
{
    [AK_DATA_CENTER set:KAK_USER_GROUP_KEY withKey:user.uid andObject:(ALModel*)user];

    [user saveOrReplce:YES];
    if(user.detail){
        [user.detail saveOrReplce:YES];
    }

    

}
-(AKUser*)user_getUserInfo:(NSString*)uid
{
    
    AKUser* user = (AKUser*)[AK_DATA_CENTER get:KAK_USER_GROUP_KEY withKey:uid];
    if(user &&  [AppHelper isNullString: user.uid] ){
        
        AKUser* tempUser = [AKUser modelsWithCondition:AS_COL(AKUser, uid).SQL_EQ(uid)].firstObject;
        if(tempUser){
            AKUserDetail* detail = [AKUserDetail modelsWithCondition:AS_COL(AKUserDetail, uid).SQL_EQ(uid)].firstObject;
            if(detail != nil && detail.uid != nil){
                tempUser.detail = detail;
            }
        }
    }
    
    return user;
 
}

@end
