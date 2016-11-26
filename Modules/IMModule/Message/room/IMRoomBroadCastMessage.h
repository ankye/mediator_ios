//
//  IMRoomBroadCastMessage.h
//  BanLiTV
//
//  Created by ZT on 16/5/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMRoomBroadCastMessage : IMMessage

@property (assign,nonatomic) NSDictionary* data;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;


@end
