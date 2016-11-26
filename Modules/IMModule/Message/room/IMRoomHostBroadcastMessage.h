//
//  IMRoomHostBroadcast.h
//  BanLiTV
//
//  Created by 栾有数 on 16/5/18.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"
#import <Foundation/Foundation.h>


@class IMRoomHostBroadModel;

@interface IMRoomHostBroadcastMessage : IMMessage


//@property (strong, nonatomic) NSDictionary * data;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;

@end
