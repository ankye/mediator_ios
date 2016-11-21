//
//  Aspect-ShareModule.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect-ShareModule.h"
#import "AKAppDelegate.h"

@implementation Aspect_ShareModule
+(void)load
{
    [AKAppDelegate aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
                           withOptions:AspectPositionBefore
                            usingBlock:^(id<AspectInfo> aspectInfo, UIApplication *applicaton, NSDictionary *launchOptions)
     {
         
        
         //打开调试日志
         [[UMSocialManager defaultManager] openLog:YES];
         
         //设置友盟appkey
         [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b432afe0f55a9832001a0a"];
         
         // 获取友盟social版本号
         //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
         
         //设置微信的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
         
         
         //设置分享到QQ互联的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
         
         //设置新浪的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
         
      
         
         
     }
            error:nil];
    
    
    
    [AKAppDelegate aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     												 withOptions:AspectPositionInstead
     													usingBlock:^(id<AspectInfo> info)
            {
     																NSArray *args = [info arguments];
     																NSInvocation *invocation = info.originalInvocation;
                                                            BOOL returnValue = [[UMSocialManager defaultManager] handleOpenURL:args[1]];
                                                            
                        
     															[invocation setReturnValue:&returnValue];
     			}
     															 error:NULL];
    
    
}
@end
