//
//  AppHelper.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"


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
 获取当前时间戳

 @return 时间戳double类型
 */
+(double) getCurrentTimestamp;


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


@end
