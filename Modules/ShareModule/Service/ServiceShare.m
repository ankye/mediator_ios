//
//  ServerShare.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceShare.h"

@implementation ServiceShare

- (void)getUserInfoForPlatform:(NSDictionary *)params
{
    UMSocialPlatformType platformType = [params[@"platformType"] integerValue];
    UIViewController* controller = params[@"controller"];
    shareGetUserinfoCompletion completion = params[@"completion"];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:controller completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userinfo =result;
        completion(userinfo,error);
    }];
}

@end
