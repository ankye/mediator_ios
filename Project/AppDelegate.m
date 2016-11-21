//
//  AppDelegate.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if( [super application:application didFinishLaunchingWithOptions:launchOptions] ){
        
       
    
        UIViewController *controller = [[AKMediator sharedInstance] map_viewController];
    
    
        self.window.rootViewController = controller;
        [self.window makeKeyWindow];
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}



@end
