//
//  IMMessageDef.h
//  BanLiTV
//
//  Created by ankye on 16/4/4.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MJExtension/MJExtension.h>

/**
 client |--------->  request  --------------->|server
        |<---------  response <---------------|
        |
        |
        |----------->timeout ---------------->|client
 
 
 client |-------->  notify   ---------------->|server
 
 
 client |<-------   push 	<----------------|server
 **/

typedef enum IMMessageType : NSInteger {
    MSG_REQUEST = 1,
    MSG_NOTIFY = 2,
    MSG_PUSH = 3,
} IMMessageType;


@protocol IMMessageDelegate <NSObject>

@optional

//request 请求request
-(BOOL)request;
//接收数据 response
-(BOOL)response:(NSArray*)info;

-(BOOL)timeout;

//notify 请求notify
-(BOOL)notify;



//接收数据 push
-(BOOL)push:(NSArray*)info;


@required

-(void)setRequestID:(int)seqID;
-(int) getRequestID;


-(IMMessageType)getMessageType;

@end
