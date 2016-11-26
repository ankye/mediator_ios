//
//  RoomSendHotGift.h
//  BanLiTV
//
//  Created by Luan Alex on 16/11/16.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface RoomSendHotGift : IMMessage

@property (copy, nonatomic)NSString * roomUid;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;


@end
