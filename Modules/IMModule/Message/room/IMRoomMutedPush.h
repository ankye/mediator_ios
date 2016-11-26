//
//  IMRoomMutedPush.h
//  BanLiTV
//
//  Created by 栾有数 on 16/5/25.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"
@class IMRoomMutedPushModel;
@interface IMRoomMutedPush : IMMessage

@end

@interface IMRoomMutedPushModel : NSObject

@property (strong, nonatomic)NSNumber * time;               //被禁言时间
@property (strong, nonatomic)NSString * toRoomuid;          //目标room_uid
@property (strong, nonatomic)NSString * mutedUid;           //被禁言，uid
@property (strong, nonatomic)NSString * mutedNick;          //被禁言，昵称
@property (strong, nonatomic)NSString * mutedForwarddata;   //被禁言，ud.forwarddata
@property (strong, nonatomic)NSString * mutedAvatorUrl;     //被禁言 头像
@property (strong, nonatomic)NSNumber * manager;            //是否是房管 0不是，1是（房管不可以被禁言，通常为0）

+ (IMRoomMutedPushModel *)gotModelFromArr:(NSArray *)arr;
@end