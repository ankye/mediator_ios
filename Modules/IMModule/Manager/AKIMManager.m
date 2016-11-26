//
//  AKIMManager.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKIMManager.h"
#import "AKIMManager+Message.h"
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
        
        
    }
    return self;
}

-(void)setIMServerList:(NSMutableArray*)serverList
{

    [GVUserDefaults standardUserDefaults].imServerList = serverList;
}



-(void)requestIMServerList
{
    [[AKRequestManager sharedInstance] im_getIMServerList:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray* response = [AppHelper arrayWithData:request.responseData];
        if(response){
            [[AKIMManager sharedInstance] setIMServerList:response];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求服务器列表失败,请重试");
    }];
    
}


/**
 通过UID获取访问IM服务器的Token
 
 @param uid 用户UID，可为空
 */
-(void)requestIMToken:(NSNumber*)uid withUserToken:(NSString*)userToken
{
    [[AKRequestManager sharedInstance] im_getIMToken:uid withUserToken:userToken success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary* response = [AppHelper dictionaryWithData:request.responseData];
        if(response && [response[@"errcode"] intValue] == 0){
            NSLog(@"result = %@",response);
            NSDictionary* data = response[@"data"];
            if(data){
                [GVUserDefaults standardUserDefaults].imToken = data[@"token"];
                [GVUserDefaults standardUserDefaults].imTime = data[@"time"];
                
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



-(BOOL)connect
{
    
    if(_wsClient == nil){
        
        UserModel* me = [[AKMediator sharedInstance] user_me];
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
    if([_wsClient readyState] == SR_OPEN){
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
        
        if( [ AppHelper getCurrentTimestamp] - _lastConnectTime >=   IM_HEARTBEAT_TIME){

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
                    
#ifdef DEBUG
                    [AFMInfoBanner showAndHideWithText:err style:AFMInfoBannerStyleInfo];
#endif
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




- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData -> NSString conversion for Text messages. Defaults to YES.
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
{
    return YES;
}


@end
