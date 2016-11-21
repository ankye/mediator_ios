//
//  ServieLogin.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceLogin.h"
#import "AKLoginViewController.h"

@implementation ServiceLogin

-(UIViewController*)fetchLoginViewController
{
    UIViewController* controller = [[AKLoginViewController alloc] init];
    return controller;
}

-(UIViewController*)fetchRegisterViewController
{
    UIViewController* controller = [[AKLoginViewController alloc] init];
    return controller;
}


@end
