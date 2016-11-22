//
//  DeviceInformation.h
//  JK360
//
//  Created by wenlong on 16/5/3.
//  Copyright © 2016年 youyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInformation : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *ip;
@property (nonatomic) BOOL isCanCarmera;
@property (nonatomic, strong) NSString *idfa;

@end
