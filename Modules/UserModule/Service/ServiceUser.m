//
//  ServiceUser.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceUser.h"
#import "UserModel.h"

@implementation ServiceUser


//登陆成功处理逻辑
-(NSNumber*)loginSuccess:(NSDictionary *)params
{
    UserModel* user = [UserModel modelWithDictionary:params[@"data"]];
    
    [[AKDataCenter sharedInstance] user_setUserInfo:user];
    

    return @(0);
}


@end
