//
//  DeviceHelper.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHelper : NSObject

//获取本机IP
+(NSString*)getLocalIP;
//获取网络IP
+(NSString*)getNetworkIP;

//获取渠道号
+ (NSString *)channel;
//获取Api版本
+ (NSNumber *)apiVersion;
//获取App版本字符串
+ (NSString *)appStringVersion;
//获取App版本数字号
+ (NSString *)appNumberVersion;


//获取设备名称 iphone/ipad/itouch
+ (NSString *)deviceName;
//获取设备系统os名称
+ (NSString *)deviceOSName;
//获取系统版本号
+ (NSString *)deviceOSVersion;
//获取设备系统os
+ (NSString *)deviceOS;
//获取IDFA
+ (NSString *)IDFA;
//获取IDFV
+ (NSString*)IDFV;




@end
