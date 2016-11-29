//
//  IMManager+Room.h
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager.h"
#import "IMRoomHostBroadcastMessage.h"


@interface AKIMManager (Room)



#pragma mark -房间发送聊天信息 是否显示弹幕：1 显示，0 不显示
- (void)roomSay:(NSString*)content isShowDanmu:(int)isShowDanmu room_uid:(NSString*)room_uid;

#pragma mark -可以进入指定房间。一旦进入房间，将会自动离开上一个房间
- (void)roomJoin:(NSString *)room_uid withComplete:(imRequestCompletion)complete;


#pragma mark -离开指定房间。如果你不在该房间，将会报 ROOM_ERROR_NOT_IN_ROOM 错误
- (void)roomLeave:(NSString *)room_uid;

#pragma mark -获取该房间内的用户列表。返回的结果已按照 noble 排序，如果 noble 一样则 uid 大的在前。
//page: 0 // 必选，页数，如要获取最前面的记录，请输入 0
- (void)roomGetUIDs:(NSString*)room_uid page:(int)page;

#pragma mark -获取该房间内的用户列表。返回的结果已按照 noble 排序，如果 noble 一样则 uid 大的在前。与 room.getUIDs 不同的是，该接口将返回更多字段。
//page: 0 // 必选，页数，如要获取最前面的记录，请输入 0
- (void)roomGetUDs:(NSString*)room_uid page:(int)page withComplete:(imRequestCompletion)complete;

#pragma mark -查询当前会话目前在哪些房间 （不包含登录时提供的 room_uid 参数的房间）
- (void)roomWhereAmI;

#pragma mark -用户点击爱心时调用。当你调用了 room.love 之后，自己也会收到对应的 room.loved
- (void)roomLove:(NSString*)room_uid;

/**
 *  推流时间戳验证 live.ping
 */
- (void)roomLivePing;

/**
 *  用户关注或分享主播成功后，发送room.broadcast广播
 *
 *  @param data        自定义json
 */
- (void)roomBroadCast:(NSDictionary *)data;

#pragma mark -房间发送广播信息 data包含广播type字段  //主播离开的字段
- (void)roomHostBroadCast:(IMRoomHostBroadModel *)hostBroadModel;

/**
 发送热门礼物

 @param room_uid 发送热门礼物的目标房间
 */
- (void)sendHotGift:(NSString *)room_uid responseBlock:(void (^)(id error)) block;

@end
