//
//  Aspect-MapModule.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect-MapModule.h"

@implementation Aspect_MapModule

+(void)load
{
    [AKAppDelegate aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
                           withOptions:AspectPositionBefore
                            usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *applicaton, NSDictionary *launchOptions)
     {
         
         [AMapServices sharedServices].apiKey = @"d891bfde6b9133506a0a31d250178b6d";
     }
                                 error:nil];
}

@end
