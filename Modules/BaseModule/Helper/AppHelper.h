//
//  AppHelper.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"

#define NETWORK_STATE_NO @"无网络"
#define NETWORK_STATE_2G @"2G"
#define NETWORK_STATE_3G @"3G"
#define NETWORK_STATE_4G @"4G"
#define NETWORK_STATE_WIFI @"WIFI"

#define NETWORK_STATE_NO_MESSAGE @"当前网络状态异常,请检查网络"
#define NETWORK_STATE_2G_MESSAGE @"您正在使用2G/3G/4G网络，可能产生额外流量"
#define NETWORK_STATE_3G_MESSAGE @"您正在使用2G/3G/4G网络，可能产生额外流量"
#define NETWORK_STATE_4G_MESSAGE @"您正在使用2G/3G/4G网络，可能产生额外流量"
#define NETWORK_STATE_WIFI_MESSAGE @"WIFI"


@interface AppHelper : NSObject


/**
 判断空字符串

 @param string 待检验string
 @return 是否为空
 */
+(BOOL)isNullString:(NSString *)string;


/**
 通过NSData获取字典，通常用于json的nsdata数据

 @param data NSData数据（由json转化过来）
 @return 返回字典
 */
+ (NSDictionary *)dictionaryWithData:(NSData *)data;

/**
 通过NSData获取数组，通常用于json的nsdata数据
 
 @param data NSData数据（由json转化过来）
 @return 返回数组
 */
+ (NSMutableArray *)arrayWithData:(NSData *)data;

/**
 获取当前时间戳

 @return 时间戳double类型
 */
+(double) getCurrentTimestamp;


/**
 获取当前时间string
 
 @return 当前时间
 */
+(NSString*) getCurrentTime;
//

/**
 获取根节点UIViewController

 @return UIViewController
 */
+ (UIViewController*)getRootController ;


/**
 获取根节点UINavigationController

 @return UINavigationController
 */
+ (UINavigationController*)getNaviController ;


/**
 毫秒级别当前时间
 
 @return 毫秒
 */
+(uint64_t)getCurrentMSTime;


/**
 获取网络状态
 
 @return 状态结果
 */
+(NSString *)getNetWorkStates;
@end
