//
//  AKMediator+ShareModule.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator+ShareModule.h"

NSString * const kAKMShareModuleService = @"Share";
NSString * const kAKMGetUserInfoForPlatform = @"getUserInfoForPlatform";


@implementation AKMediator (ShareModule)

- (void)share_getUserInfoForPlatform:(UMSocialPlatformType) platformType withController:(UIViewController*)controller withCompletion:(shareGetUserinfoCompletion)completion
{
     [self performService:kAKMShareModuleService action:kAKMGetUserInfoForPlatform params:@{@"platformType":@(platformType),@"controller":controller,@"completion":completion} shouldCacheService:NO];
}

@end
