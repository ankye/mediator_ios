//
//  AKMapManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMapManager.h"

@implementation AKMapManager

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKMapManager *_mapManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapManager = [[AKMapManager alloc] init];
        
    });
    return _mapManager;
}


@end
