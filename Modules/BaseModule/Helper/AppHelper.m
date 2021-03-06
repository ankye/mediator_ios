//
//  AppHelper.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AppHelper.h"



@implementation AppHelper

+(NSString*)appName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleName"];

}

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
 通过NSData获取数组，通常用于json的nsdata数据
 
 @param data NSData数据（由json转化过来）
 @return 返回数组
 */
+ (NSMutableArray *)arrayWithData:(NSData *)data;
{
    NSError *error;
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
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

+(NSDate*) getCurrentDate
{
    return [NSDate date];
}

/**
 获取当前时间string

 @return 当前时间
 */
+(NSString*) getCurrentTime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datetime = [formatter stringFromDate:[NSDate date]];
    return datetime;
}

+(double)getTimestampFromString:(NSString*)string
{
    if([AppHelper isNullString:string]){
        return 0;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return [date timeIntervalSince1970];
}

+(NSDate*)getDateFromMSTime:(double)time
{
   return [NSDate dateWithTimeIntervalSince1970:time/1000];
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


/**
 毫秒级别当前时间

 @return 毫秒
 */
+(uint64_t)getCurrentMSTime
{
    return [[NSDate date] timeIntervalSince1970]*1000;
}



/**
 获取网络状态

 @return 状态结果
 */
+(NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = NETWORK_STATE_NO;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = NETWORK_STATE_NO;
                    //无网模式
                    break;
                case 1:
                    state = NETWORK_STATE_NO;//NETWORK_STATE_2G;
                    break;
                case 2:
                    state = NETWORK_STATE_3G;
                    break;
                case 3:
                    state = NETWORK_STATE_4G;
                    break;
                case 4:
                    state = NETWORK_STATE_4G;
                 
                    break;
                case 5:
                {
                    state = NETWORK_STATE_WIFI;
                }
                    break;
                default:
                    state = NETWORK_STATE_4G;
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

/**
 设置状态栏背景颜色
 
 @param color 颜色
 */
+ (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}

/**
 设置状态栏字体颜色
 
 @param color 颜色
 */
+ (BOOL)setStatusBarFontColor:(UIColor *)color
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
    //    [statusBar performSelector:setForegroundColor_sel withObject:color];这个会有警告，为了消除警告使用了下方替代方法
        IMP imp = [statusBar methodForSelector:setForegroundColor_sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(statusBar, setForegroundColor_sel,color);
        return YES;
    }
    return NO;

}

@end
