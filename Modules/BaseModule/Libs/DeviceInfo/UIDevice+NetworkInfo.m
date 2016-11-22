//
//  UIDevice+NetworkInfo.m
//  JK360
//
//  Created by wenlong on 16/5/3.
//  Copyright © 2016年 youyi. All rights reserved.
//

#import "UIDevice+NetworkInfo.h"
#import "DeviceInformation.h"

@implementation UIDevice (NetworkInfo)

+ (NSString *)ip {
    return [[DeviceInformation sharedInstance] ip];
}
@end
