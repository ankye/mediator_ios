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
        
        [[AKMediator sharedInstance] updateAppScheme:@"banliapp"];
    
        
        UIViewController *controller = [[AKMediator sharedInstance] map_viewController];
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
    
        
        self.window.rootViewController = navigationController;
        
        
        [self.window makeKeyWindow];
        [self.window makeKeyAndVisible];
        
        [[AKMediator sharedInstance] im_requestIMServerList];
       
        if(![[AKMediator sharedInstance] user_isUserLogin]){
            UIViewController* loginController = [[AKMediator sharedInstance] login_viewControllerForLogin];
            [[AppHelper getRootController] presentViewController:loginController animated:YES completion:nil];
        }else{
            UserModel* me = [[AKMediator sharedInstance] user_me];
            [[AKMediator sharedInstance] im_requestIMToken:me.uid withUserToken:me.token];
        }
        
        
        
    }
    
    return YES;
}



@end
