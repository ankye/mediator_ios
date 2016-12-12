//
//  AKRequestManager+IMModule.h
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@interface AKRequestManager (IMModule)


/**
 从PHP那边获取访问IM的token
 
 @param uid 用户ID
 @parem userToken 用户Web Token
 @param success 成功回调
 @param failure 失败回调
 */
-(void)im_getIMToken:(NSString*)uid withUserToken:(NSString*)userToken success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

/**
 请求获取IM服务器列表

 @param success 成功回调
 @param failure 失败回调
 */
-(void)im_getIMServerList:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;


@end
