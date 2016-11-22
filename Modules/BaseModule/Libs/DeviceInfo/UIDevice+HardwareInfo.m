//
//  UIDevice+HardwareInfo.m
//  JK360
//
//  Created by wenlong on 16/5/3.
//  Copyright © 2016年 youyi. All rights reserved.
//

#import "UIDevice+HardwareInfo.h"
#import "DeviceInformation.h"


@implementation UIDevice(HardwareInfo)

+ (BOOL)isCanCarmera {
    return [[DeviceInformation sharedInstance] isCanCarmera];
}

@end
