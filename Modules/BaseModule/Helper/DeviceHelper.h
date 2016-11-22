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
+(NSString*)localIP;
//获取网络IP
+(NSString*)networkIP;

//获取渠道号
+ (NSString *)channel;
//获取Api版本
+ (NSString *)apiVersion;
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

//获取系统mac地址
+ (NSString*)macAddress;


/**
 *  获取当前系统语言
 *
 *  @return zh_CN, zh_TW, ja_JP, en_US
 */
+ (NSString *)localeLanguage;

//机器品牌
+ (NSString*)phoneBrand;
//手机型号
+ (NSString*)phoneModel;
@end
