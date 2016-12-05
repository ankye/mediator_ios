//
//  AppDelegate.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AppDelegate.h"
#import "AKSignalManager+MapModule.h"
#import "AKSignalManager+UserModule.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if( [super application:application didFinishLaunchingWithOptions:launchOptions] ){
        
        [AK_MEDIATOR updateAppScheme:@"banliapp"];
    
        
        UIViewController *controller = [AK_MEDIATOR map_viewController];
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
    
        
        self.window.rootViewController = navigationController;
        
        
        [self.window makeKeyWindow];
        [self.window makeKeyAndVisible];
        
        [AK_MEDIATOR im_requestIMServerList];
       
        if(![AK_MEDIATOR user_isUserLogin]){
            UIViewController* loginController = [AK_MEDIATOR login_viewControllerForLogin];
            [[AppHelper getRootController] presentViewController:loginController animated:YES completion:nil];
        }
       
   
        
    }

    return YES;
}


@end
