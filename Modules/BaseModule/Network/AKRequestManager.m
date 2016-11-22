//
//  AKRequestManager.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@implementation AKRequestManager


#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKRequestManager *_requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestManager = [[AKRequestManager alloc] init];
    });
    return _requestManager;
}



@end
