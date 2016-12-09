//
//  AKTabbarControllerFactory.m
//  Project
//
//  Created by ankye on 2016/11/11.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKTabbarControllerFactory.h"
#import "CYLTabBarController.h"
#import "AKCYLPlusButton.h"

@implementation AKTabbarControllerFactory

SINGLETON_IMPL(AKTabbarControllerFactory)

-(UITabBarController*)createWithPlist:(NSString*)plist
{
    NSArray* tabs = [FileHelper getArrayFromPlist:plist];
    
    NSMutableArray* vcArrs = [[NSMutableArray alloc] init];
    NSMutableArray *attributes =  [[NSMutableArray alloc] init];
    for (int i=0; i<[tabs count]; i++)
    {
        NSDictionary* dic = [tabs objectAtIndex:i];
        
        NSString* plusButtonName = dic[@"plusButton"];
        
        if(![AppHelper isNullString:plusButtonName]) {
            //  Class plusClass =  NSClassFromString(dic[@"plusButton"]);
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            
            dict[CYLTabBarItemTitle] = dic[@"title"];
            dict[CYLTabBarItemImage] = dic[@"normal"];
            dict[CYLTabBarItemSelectedImage] = dic[@"selected"];
            
            dict[@"count"] = @([tabs count]);
            
            [[AKCYLPlusButton defaultInstance] setAttributes:dict];
            [AKCYLPlusButton registerPlusButton];
            
        }else{
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
            NSString* title = dic[@"title"];
            if( ![AppHelper isNullString:title]){
                dict[CYLTabBarItemTitle] = title;
            }
            NSString* normal = dic[@"normal"];
            if( ![AppHelper isNullString:normal]){
                dict[CYLTabBarItemImage] = normal;
            }
            NSString* selected = dic[@"selected"];
            if( ![AppHelper isNullString:selected]){
                dict[CYLTabBarItemSelectedImage] = selected;
            }
            [attributes addObject:dict];
            
            Class aClass = NSClassFromString(dic[@"controller"]);
            
            UIViewController *viewController = [[aClass alloc] init];
            if(![AppHelper isNullString:dic[@"navigationController"]]){
                
                Class nvClass = NSClassFromString(dic[@"navigationController"]);
                UINavigationController *navigationController = [[nvClass alloc] initWithRootViewController:viewController];
                [vcArrs addObject:navigationController];
                
            }else{
                [vcArrs addObject:viewController];
            }
        }
    };
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    
    [tabBarController setTabBarItemsAttributes:attributes];
    
    [tabBarController setViewControllers:vcArrs];
    return tabBarController;
}
@end
