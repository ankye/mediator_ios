//
//  AKRequestHeader.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestHeader.h"

@implementation AKRequestHeader
+(void)load
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary: @{
        @"API-VERSION": [DeviceHelper apiVersion],
        @"USER-UID": @"",
        @"USER-TOKEN": @"",
        @"PLATFORM": @"IOS",
        @"APP-SOURCE"  : [DeviceHelper channel],
        @"Version"     :[DeviceHelper appStringVersion],
        @"Device-ID"   :[DeviceHelper macAddress],
        @"idfa"        :[DeviceHelper IDFA],
        @"APP-LEVEL-VERSION" : @"2",
        @"locale"      :[DeviceHelper localeLanguage],
        @"USER-MPHONE-BRAND":[DeviceHelper phoneBrand],//手机品牌
        @"USER-MPHONE-MODELS": [DeviceHelper phoneModel],//手机型号
        @"USER-MPHONE-OS-VER":[DeviceHelper deviceOSVersion]//系统版本号
        }];
    
    [[AKRequestManager sharedInstance] setHttpHeaderWithDictionary:dic];
    

}
@end
