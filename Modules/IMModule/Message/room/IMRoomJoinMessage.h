//
//  IMRoomJoinMessage.h
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomJoinMessage :IMMessage

@property (assign,nonatomic) NSString* room_uid;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
