//
//  LoginRequestFactory.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager+LoginModule.h"
#import "ThirdLoginAPI.h"

@implementation AKRequestManager (LoginModule)

-(BOOL)login_requestThridLoginWithOpenID:(NSString *)openid withToken:(NSString *)token withPlatformType:(NSInteger )platformType Success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    

    NSString *type = @"";
    
    switch (platformType) {
        case UMSocialPlatformType_QQ:
            type = @"qq_connect";
            break;
        case UMSocialPlatformType_WechatSession:
            type = @"weixin_connect";
            break;
        case UMSocialPlatformType_Sina:
            type = @"weibo_connect";
            break;
        
        default:
            break;
    }

    ThirdLoginAPI *api = [[ThirdLoginAPI alloc] init:openid withToken:token andType:type];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
   
    return YES;
}


@end
