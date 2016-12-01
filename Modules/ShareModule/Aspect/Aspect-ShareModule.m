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
         [[UMSocialManager defaultManager] openLog:NO];
         
         //设置友盟appkey
         [[UMSocialManager defaultManager] setUmSocialAppkey:UM_DATA_KEY];
         
         // 获取友盟social版本号
         //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
         
         //设置微信的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UM_WEIXIN_APPID appSecret:UM_WEIXIN_APPSEC redirectURL:UM_WEIXIN_REDIRECT];
         
         
         //设置分享到QQ互联的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UM_QQ_APPID appSecret:UM_QQ_APPSEC redirectURL:UM_QQ_REDIRECT];
         
         //设置新浪的appKey和appSecret
         [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UM_WEIBO_APPKEY  appSecret:UM_WEIBO_APPSEC redirectURL:UM_WEIBO_REDIRECT];
         
      
         
         
     }
            error:nil];
    
    
    [AKAppDelegate aspect_hookSelector:@selector(application:handleOpenURL:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info, UIApplication *applicaton,NSURL *url ){
        

        NSInvocation *invocation = info.originalInvocation;
        BOOL returnValue = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        
        [invocation setReturnValue:&returnValue];
        
    }error:nil];
    
    [AKAppDelegate aspect_hookSelector:@selector(application:openURL:options:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info,UIApplication *app ,NSURL *url ,NSDictionary<UIApplicationOpenURLOptionsKey,id> * options){
        
       
        NSInvocation *invocation = info.originalInvocation;
        BOOL returnValue = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        
        [invocation setReturnValue:&returnValue];
        
    }error:nil];
    
    
    [AKAppDelegate aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     												 withOptions:AspectPositionInstead
usingBlock:^(id<AspectInfo> info,UIApplication *application ,NSURL *url ,NSString *sourceApplication, id annotation)
            {
                
     																NSInvocation *invocation = info.originalInvocation;
                                                            BOOL returnValue = [[UMSocialManager defaultManager] handleOpenURL:url];
                                                            
                        
     															[invocation setReturnValue:&returnValue];
     			}
     															 error:NULL];
    
    
}
@end
