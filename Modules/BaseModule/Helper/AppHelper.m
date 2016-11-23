//
//  AppHelper.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AppHelper.h"


@implementation AppHelper


/**
 通过NSData获取字典，通常用于json的nsdata数据
 
 @param data NSData数据（由json转化过来）
 @return 返回字典
 */
+ (NSDictionary *)dictionaryWithData:(NSData *)data;
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        return result;
    }
    return nil;
}


/**
 判断空字符串
 
 @param string 待检验string
 @return 是否为空
 */
+(BOOL)isNullString:(NSString *)string
{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

/**
 获取当前时间戳
 
 @return 时间戳double类型
 */
+(double) getCurrentTimestamp
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    return (double)time;      //NSTimeInterval返回的是double类型
    
}


/**
 获取根节点UIViewController
 
 @return UIViewController
 */
+ (UIViewController*)getRootController {
    UIViewController* root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}


/**
 获取根节点UINavigationController
 
 @return UINavigationController
 */

+ (UINavigationController*)getNaviController {
    UIViewController* root = [AppHelper getRootController];
    if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tab = (UITabBarController*)root;
        return tab.selectedViewController;
    }
    return (UINavigationController*)root;
}


@end
