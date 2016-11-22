//
//  ServiceMap.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceMap.h"
#import "AKMapViewController.h"

@implementation ServiceMap

-(UIViewController*)fetchMapViewController:(NSDictionary *)params
{
    UIViewController* controller = [[AKMapViewController alloc] init];
    return controller;
}

@end
