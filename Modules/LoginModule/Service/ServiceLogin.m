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

-(UIViewController*)fetchLoginViewController:(NSDictionary *)params
{
    UIViewController* controller = [[AKLoginViewController alloc] init];
    return controller;
}

-(UIViewController*)fetchRegisterViewController:(NSDictionary *)params
{
    UIViewController* controller = [[AKLoginViewController alloc] init];
    return controller;
}


@end
