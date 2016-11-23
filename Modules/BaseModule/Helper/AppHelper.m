//
//  AppHelper.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AppHelper.h"


@implementation AppHelper



+ (NSDictionary *)dictionaryWithData:(NSData *)data;
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        return result;
    }
    return nil;
}

//判断空字符串
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


+ (UIViewController*)getRootController {
    UIViewController* root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

+ (UINavigationController*)getNaviController {
    UIViewController* root = [AppHelper getRootController];
    if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tab = (UITabBarController*)root;
        return tab.selectedViewController;
    }
    return (UINavigationController*)root;
}


@end
