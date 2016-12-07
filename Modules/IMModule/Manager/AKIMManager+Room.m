//
//  IMManager+Room.m
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager+Room.h"
#import "AKIMManager.h"
#import "AKIMManager+Message.h"
#import "IMRoomJoinMessage.h"
#import "IMRoomSayMessage.h"
#import "IMRoomLeaveMessage.h"
#import "IMRoomGetUIDsMessage.h"
#import "IMRoomGetUDsMessage.h"
#import "IMRoomWhereAmIMessage.h"
#import "IMRoomLoveMessage.h"
#import "IMRoomBroadCastMessage.h"
#import "AKIMManager+Common.h"
#import "IMLivePingMessage.h"
#import "RoomSendHotGift.h"

@implementation AKIMManager (Room)


#pragma mark -进入房间
- (void)roomJoin:(NSString *)room_uid withComplete:(imRequestCompletion)complete{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomJoin room_uid not nil");
#else
    if (room_uid == nil) return;
#endif
    
 
    DDLogInfo(@"开始进房");
    IMRoomJoinMessage* message = (IMRoomJoinMessage*)[self createMessage:@"room.join"];
    message.room_uid = room_uid;
    message.complete = complete;
    
    [self postMessage:message];

  
}


#pragma mark -房间发送聊天信息 是否显示弹幕：1 显示，0 不显示
- (void)roomSay:(NSString*)content isShowDanmu:(int)isShowDanmu room_uid:(NSString*)room_uid
{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomSay room_uid not nil");
#else
    if (room_uid == nil) return;
#endif

    IMRoomSayMessage* message = (IMRoomSayMessage*)[self createMessage:@"room.say"];
    message.room_uid = room_uid;
    message.content = content;
    message.isShowDanmu = isShowDanmu;
    
    [self postMessage:message];

}


#pragma mark -离开指定房间。如果你不在该房间，将会报 ROOM_ERROR_NOT_IN_ROOM 错误
- (void)roomLeave:(NSString *)room_uid
{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomLeave room_uid not nil");
#else
    if (room_uid == nil) return;
#endif
    
    IMRoomLeaveMessage* message = (IMRoomLeaveMessage*)[self createMessage:@"room.leave"];
    message.room_uid = room_uid;
    [self postMessage:message];
//    self.lastRoomID = nil;

}

#pragma mark -获取该房间内的用户列表。返回的结果已按照 noble 排序，如果 noble 一样则 uid 大的在前。
//page: 0 // 必选，页数，如要获取最前面的记录，请输入 0
- (void)roomGetUIDs:(NSString*)room_uid page:(int)page
{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomGetUIDs room_uid not nil");
#else
    if (room_uid == nil) return;
#endif

    IMRoomGetUIDsMessage* message = (IMRoomGetUIDsMessage*)[self createMessage:@"room.getUIDs"];
    message.room_uid = room_uid;
    message.page = page;
    [self postMessage:message];

}

#pragma mark -获取该房间内的用户列表。返回的结果已按照 noble 排序，如果 noble 一样则 uid 大的在前。与 room.getUIDs 不同的是，该接口将返回更多字段。
//page: 0 // 必选，页数，如要获取最前面的记录，请输入 0
- (void)roomGetUDs:(NSString*)room_uid page:(int)page withComplete:(imRequestCompletion)complete
{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomGetUIDs room_uid not nil");
    DDLogInfo(@"Room getUDS roomid=[%@] and page=[%d]",room_uid,page);
    
#else
    if (room_uid == nil) return;
#endif

    IMRoomGetUDsMessage* message = (IMRoomGetUDsMessage*)[self createMessage:@"room.get_uds"];
    message.room_uid = room_uid;//room.get_uds
    message.page = page;
    message.complete = complete;
    
    [self postMessage:message];

}


#pragma mark -查询当前会话目前在哪些房间 （不包含登录时提供的 room_uid 参数的房间）
- (void)roomWhereAmI
{
    IMRoomWhereAmIMessage* message = (IMRoomWhereAmIMessage*)[self createMessage:@"room.whereami"];

    [self postMessage:message];

}

#pragma mark -用户点击爱心时调用。当你调用了 room.love 之后，自己也会收到对应的 room.loved
- (void)roomLove:(NSString*)room_uid
{
#ifdef DEBUG
    NSAssert(room_uid != nil, @"roomLove room_uid not nil");
#else
    if (room_uid == nil) return;
#endif

    IMRoomLoveMessage* message = (IMRoomLoveMessage*)[self createMessage:@"room.love"];
    message.room_uid = room_uid;
    [self postMessage:message];

}

- (void)roomLivePing
{
    IMLivePingMessage* message = (IMLivePingMessage*)[self createMessage:@"live.ping"];
    [self postMessage:message];
    
}

#pragma mark -房间发送广播信息 data包含广播type字段
- (void)roomBroadCast:(NSDictionary *)data
{
#ifdef DEBUG
    NSAssert(data != nil, @"room.broadcast data not nil");
#else
    if (data == nil) return;
#endif

    IMRoomBroadCastMessage* message = (IMRoomBroadCastMessage*)[self createMessage:@"room.broadcast"];
    message.data = data;
    
    [self postMessage:message];

}

#pragma mark -房间发送广播信息 data包含广播type字段  //主播离开的字段
- (void)roomHostBroadCast:(IMRoomHostBroadModel *)hostBroadModel
{
#ifdef DEBUG
    NSAssert(hostBroadModel != nil, @"room.broadcast data not nil");
#else
    if (hostBroadModel == nil) return;
#endif
    
    IMRoomHostBroadcastMessage * message = (IMRoomHostBroadcastMessage*)[self createMessage:@"room.host_broadcast"];
  
    [self postMessage:message];

}
/**
 发送热门礼物

 @param room_uid 发送热门礼物的目标房间
 */
- (void)sendHotGift:(NSString *)room_uid responseBlock:(void (^)(id error)) block{
    RoomSendHotGift * message = (RoomSendHotGift *)[self createMessage:@"room.send_hot_gift"];
    message.roomUid = room_uid;
    message.responseBlock = block;
    [self postMessage:message];
}
@end
