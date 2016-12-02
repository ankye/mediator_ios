//
//  AKIMManager.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKIMManager.h"
#import "AKIMManager+Message.h"
#import "AKIMManager+Common.h"

#import "AKTimerManager.h"


@interface AKIMManager ()
{
 
 
    
    NSTimeInterval   _lastConnectTime;
    //timer相关设置
    int             _connectTimeout;
    int             _requestTimeout;
    int             _heartbeatTime;
    
    //socket 相关
    NSString*       _serverUrl;

    int                 _requestID;
    NSMutableDictionary*  _requestMap;
    
    
    dispatch_queue_t _imManagerQueue;
}

@end


@implementation AKIMManager

SINGLETON_IMPL(AKIMManager);


-(id)init
{
    if(self = [super init]){
     
        _requestID = 0;
        _connectTimeout = IM_CONNECT_TIMEOUT;
        _requestTimeout = IM_REQUEST_TIMEOUT;
        _heartbeatTime = IM_HEARTBEAT_TIME;
        
        _imManagerQueue = dispatch_queue_create("com.ak.im.manager.queue", 0);
        _requestMap = [[NSMutableDictionary alloc] init];

         _messageClassPool = [[NSMutableDictionary alloc] init];
        
        [self messageRegister];
        
        [self setupTimer];
        
    }
    return self;
}

-(void)setIMServerList:(NSMutableArray*)serverList
{

    [GVUserDefaults standardUserDefaults].imServerList = serverList;
}



-(void)requestIMServerList
{
    [AK_REQUEST_MANAGER im_getIMServerList:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray* response = [AppHelper arrayWithData:request.responseData];
        if(response){
            [[AKIMManager sharedInstance] setIMServerList:response];
        }else{
           
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求服务器列表失败,请重试");
        [self setIMServerList:[[NSMutableArray alloc] initWithObjects:@"test.im.blres.com:13001", nil]];
    }];
    
}


/**
 通过UID获取访问IM服务器的Token
 
 @param uid 用户UID，可为空
 */
-(void)requestIMToken:(NSNumber*)uid withUserToken:(NSString*)userToken
{
    [AK_REQUEST_MANAGER im_getIMToken:uid withUserToken:userToken success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary* response = [AppHelper dictionaryWithData:request.responseData];
        if(response && [response[@"errcode"] intValue] == 0){
            NSLog(@"result = %@",response);
            NSDictionary* data = response[@"data"];
            if(data){
                [GVUserDefaults standardUserDefaults].imToken = data[@"token"];
                [GVUserDefaults standardUserDefaults].imTime = data[@"time"];
                
                //请求成功，尝试连接IM
                [self connect];
            }
        }else{
            NSLog(@"请求失败,请重试");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求IM服务器Token,请重试");
    }];
}

-(int) genRequestID
{
    _requestID +=1;
    if(_requestID >=1000000){
        _requestID = 1;
    }
    return _requestID;
}

-(BOOL)postMessage:(id<IMMessageDelegate>)message
{
    
    NSLog(@"Process Post Message %s",object_getClassName(message));
    
    if( [message getMessageType] == MSG_REQUEST){
        [message setRequestID:[self genRequestID]];
        dispatch_async(_imManagerQueue, ^{
            [self cacheRequest:message];
        });
        
        return [message request];
        
    }else if ( [message getMessageType] == MSG_NOTIFY ){
        
        return [message notify];
    }
    
    return NO;
    
}



-(void)cacheRequest:(id<IMMessageDelegate>)message
{
    [_requestMap setObject:message forKey:[NSString stringWithFormat:@"%d",[message getRequestID]]];
    
}

-(void)removeRequestByKey:(NSString*)key timerID:(NSInteger)index
{
    dispatch_async(_imManagerQueue, ^{
    
        [_requestMap removeObjectForKey:key];
    });
}


/**
 安装定时器
 */
-(void)setupTimer
{
    //IM服务器链接10检测一次，断开重连
    [AK_TIME_MANAGER addTimerWithInterval:10 withUniqueID:@"AKIMConnectCheckTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        if( [self isConnected] == NO){
            NSLog(@"重新连接IM服务器");
            [self connect];
        }
    }];
 
    [AK_TIME_MANAGER addTimerWithInterval:10 withUniqueID:@"AKIMHeartBeatTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        if([self isConnected]){
            NSLog(@"执行心跳处理");
            [self heartbeat];
        }
    }];
    
    
    
}

-(BOOL)connect
{
    
    if(_wsClient == nil){
        
        _lastConnectTime = [AppHelper getCurrentTimestamp];
        
        UserModel* me = [AK_MEDIATOR user_me];
        if(!me){
            return NO;
        }
        
        NSArray* serverList = [GVUserDefaults standardUserDefaults].imServerList;
        if(serverList == nil){
            return NO;
        }
        
        NSString* server = [serverList objectAtIndex:0];
        if ([AppHelper isNullString:server]) {
            return NO;
        }
        
        NSString* imToken = [GVUserDefaults standardUserDefaults].imToken;
        if([AppHelper isNullString:imToken]){
            return NO;
        }
        
        NSNumber* imTime = [GVUserDefaults standardUserDefaults].imTime;
        if(imTime == nil){
            return NO;
        }
        
        
        
        _serverUrl = [NSString stringWithFormat:@"ws://%@?client_os=ios&client_version=%@&locale=%@&uid=%ld&room_uid=0&time=%ld&token=%@",server,[DeviceHelper appStringVersion],[DeviceHelper localeLanguage],[me.uid integerValue],[imTime integerValue],imToken];
        
        _wsClient = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:_serverUrl]];
        _wsClient.delegate = self;
        
        [_wsClient open];
        
    }
    
    return YES;
}


-(void)disconnect
{
    
    if(_wsClient){
        [_wsClient close];
        _wsClient = nil;
    }
    
}



-(BOOL)isConnected
{
    if(_wsClient && [_wsClient readyState] == SR_OPEN){
        return YES;
    }else{
        return NO;
    }
    
}


-(BOOL)sendData:(NSString*)commandStr
{
    if( [self isConnected] ){
        
        [[self wsClient] send:commandStr];
        return YES;
    }else{
        
        if( _wsClient == nil){
            [self connect];
        }
        return NO;
    }
}


#pragma websocket delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)response;
{
    
    dispatch_async(_imManagerQueue, ^{
        
        NSArray *info = [response mj_JSONObject];
        if(info == nil){
            return;
        }
        NSString* cmd = [info objectAtIndex:0];
        if([info count] >=2){
            NSDictionary* dic = info[1];
            //            if ([dic isEqual:[NSNull null]]) {
            //                return;
            //            }
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                if( [dic objectForKey:@"code"] !=nil && [dic objectForKey:@"name"] != nil){
                    
                    NSString* err = [NSString stringWithFormat: @"[WebSocket] cmd:(%@) Code:( %@ ) Value:( %@ )", cmd,[dic objectForKey:@"code"],[dic objectForKey:@"name"]];
                    NSLog(@"socket 接受数据错误 %@",err);
                    
                }
                
            }
        }
        id<IMMessageDelegate> message = [_requestMap objectForKey:cmd];
        if(message){
            
            [message response:info];
            
            return;
        }
        
        message =  (id<IMMessageDelegate>)[self createMessage:cmd];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(message){
                [message push:info];
            }
        });
        return;
        
        
    });
}


//这个OPEN状态以后才可以发送数据

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [self disconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [self disconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}






@end
