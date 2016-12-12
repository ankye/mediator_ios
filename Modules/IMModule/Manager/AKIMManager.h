//
//  AKIMManager.h
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import "IMMessageDef.h"

#define IM_CONNECT_TIMEOUT      30 // 默认连接超时时间
#define IM_TRY_RECONNECT_TIMES      3  // 重连次数
#define IM_HEARTBEAT_TIME       15 // 默认心跳时间
#define IM_REQUEST_TIMEOUT      30 // 默认请求超时时间


@interface AKIMManager : NSObject <SRWebSocketDelegate>


@property (strong,nonatomic,readwrite) SRWebSocket *wsClient;
@property (strong,nonatomic,readwrite) NSMutableDictionary* messageClassPool;

SINGLETON_INTR(AKIMManager);


/**
 请求im服务器列表
 */
-(void)requestIMServerList;


/**
 通过UID获取访问IM服务器的Token

 @param uid 用户UID，可为空
 @param userToken 用户web登录授权token
 */
-(void)requestIMToken:(NSString*)uid withUserToken:(NSString*)userToken;

-(void)setIMServerList:(NSMutableArray*)serverList;

-(BOOL)isConnected;

-(BOOL)sendData:(NSString*)commandStr;

-(BOOL)postMessage:(id<IMMessageDelegate>)message;

@end
