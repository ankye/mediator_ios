//
//  LoginModuleMediator.m
//  Project
//
//  Created by ankye sheng on 2017/7/12.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "LoginModuleMediator.h"

NSString * const kAKMLoginModuleLoginService = @"Login";
NSString * const kAKMLoginModuleFetchLoginVC = @"fetchLoginViewController";
NSString * const kAKMLoginModuleFetchRegisterVC = @"fetchRegisterViewController";



@implementation AKMediator (LoginModule)



- (UIViewController *)login_viewControllerForLogin
{
    UIViewController* viewController = [self performService:kAKMLoginModuleLoginService action:kAKMLoginModuleFetchLoginVC params:@{@"key":@"value"} shouldCacheService:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}
- (UIViewController *)login_viewControllerForRegister
{
    UIViewController* viewController = [self performService:kAKMLoginModuleLoginService action:kAKMLoginModuleFetchLoginVC params:@{@"key":@"value"} shouldCacheService:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}


@end
