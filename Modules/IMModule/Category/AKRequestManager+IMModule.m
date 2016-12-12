//
//  AKRequestManager+IMModule.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager+IMModule.h"
#import "AKIMTokenRequest.h"
#import "AKIMServerListRequest.h"

@implementation AKRequestManager (IMModule)

/**
 从PHP那边获取访问IM的token
 
 @param uid 用户ID
 @parem userToken 用户Web Token
 @param success 成功回调
 @param failure 失败回调
 */
-(void)im_getIMToken:(NSString*)uid withUserToken:(NSString*)userToken success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
 
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"API-VERSION" withValue:@"2.0"];
     [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-UID" withValue: uid];
     [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-TOKEN" withValue:userToken];

    AKIMTokenRequest* request = [[AKIMTokenRequest alloc] init:uid];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
}


/**
 请求获取IM服务器列表
 
 @param success 成功回调
 @param failure 失败回调
 */
-(void)im_getIMServerList:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    AKIMServerListRequest* request = [[AKIMServerListRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];

}

@end
