//
//  IMMessage.h
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageDef.h"
#import "AKIMManager.h"

#define IMTimeOut [[NSError alloc] initWithDomain:@"im请求超时" code:-10000 userInfo:nil]

@interface IMMessage : NSObject <IMMessageDelegate>

@property (assign,nonatomic) IMMessageType messageType;
@property (nonatomic,copy)   imRequestCompletion complete;


-(void)setRequestID:(int)seqID;
-(int) getRequestID;

@property (copy, nonatomic)void (^responseBlock)(id error);  //error== nil:请求成功,IMTimeOut:请求超时

-(IMMessageType)getMessageType;
@end
