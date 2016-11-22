//
//  AKDataCenter.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter.h"

@implementation AKDataCenter

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKDataCenter *_dataCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataCenter = [[AKDataCenter alloc] init];
    });
    return _dataCenter;
}


@end
