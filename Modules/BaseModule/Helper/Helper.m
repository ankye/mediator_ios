//
//  Helper.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Helper.h"


@implementation Helper


+(NSArray*)getPlist:(NSString*)name
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"plist"]];
    
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
    UIViewController* root = [Helper getRootController];
    if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tab = (UITabBarController*)root;
        return tab.selectedViewController;
    }
    return (UINavigationController*)root;
}


@end
