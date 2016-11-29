//
//  ServiceIM.h
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceIM : NSObject

/**
 请求im服务器列表，保存在IMManager里面

 @param params 请求参数字典
 @return YES OR NO
 */
-(NSNumber*)requestIMServerList:(NSDictionary*)params;


/**
 从WEB服务器请求IM访问token

 @param params 请求参数字典
 @return YES OR NO
 */
-(NSNumber*)requestIMToken:(NSDictionary*)params;


/**
 聊天列表

 @param params 参数列表
 @return 返回聊天列表视图
 */
-(UIView*)conversationView:(NSDictionary*)params;


@end
