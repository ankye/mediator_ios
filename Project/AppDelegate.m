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
#import "AKTabbarControllerFactory.h"
#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if( [super application:application didFinishLaunchingWithOptions:launchOptions] ){
        
        [AK_MEDIATOR updateAppScheme:@"banliapp"];
        
 
       
        
//        UIViewController *controller = [AK_MEDIATOR map_viewController];
//        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//        
//    
//        
//        self.window.rootViewController = navigationController;
//
        self.window.rootViewController = [[AKTabbarControllerFactory sharedInstance] createWithPlist:@"TabBar"];
        [self customizeInterface];
        
      
        
        
        [self.window makeKeyWindow];
        [self.window makeKeyAndVisible];
        
//        [AK_MEDIATOR im_requestIMServerList];
//       
//        if(![AK_MEDIATOR user_isUserLogin]){
//            UIViewController* loginController = [AK_MEDIATOR login_viewControllerForLogin];
//            [[AppHelper getRootController] presentViewController:loginController animated:YES completion:nil];
//        }
//       
   
       
        
    }

    return YES;
}



/**
 *  tabBarItem 的选中和不选中文字属性、背景图片
 */
- (void)customizeInterface {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [HXColor colorWithHexString:@"#09bb07"];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundColor:[HXColor colorWithHexString:@"#eeeeee"]];

}


@end
