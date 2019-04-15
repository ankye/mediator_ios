//
//  LoginModuleMediator.h
//  Project
//
//  Created by ankye sheng on 2017/7/12.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceLogin.h"


#import "AKRequestManager+LoginModule.h"

@interface AKMediator (LoginModule)



- (UIViewController *)login_viewControllerForLogin;

- (UIViewController *)login_viewControllerForRegister;


@end
