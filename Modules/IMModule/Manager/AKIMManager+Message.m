//
//  AKIMManager+Message.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKIMManager+Message.h"

#import "AKIMManager.h"
#import "IMMessage.h"
//import message class
//heartbeat
#import "IMHeartBeatNotify.h"

//live
#import "IMLivePingMessage.h"

//Room
#import "IMRoomGetUIDsMessage.h"
#import "IMRoomGetUDsMessage.h"
#import "IMRoomLiveofflinePush.h"
#import "IMRoomSayMessage.h"
#import "IMRoomGivedPush.h"
#import "IMRoomLoveMessage.h"
#import "IMRoomSetNutsPush.h"
#import "IMRoomJoinMessage.h"
#import "IMRoomLovedPush.h"
#import "IMRoomSetRMPush.h"
#import "IMRoomJoinedPush.h"
#import "IMRoomRenqiChangePush.h"
#import "IMRoomWhereAmIMessage.h"
#import "IMRoomLeaveMessage.h"
#import "IMRoomSaidPush.h"
#import "IMRoomBroadCastMessage.h"
#import "IMRoomBroadCastedPush.h"
#import "IMRoomGived2Push.h"

//IM
#import "IMSaidPush.h"
#import "IMSayMessage.h"
#import "IMGetMessage.h"
#import "IMGetMaxIndicesMessage.h"


//session
#import "IMLoginSuccessPush.h"
#import "IMUserErrorPush.h"
#import "IMSessionKickPush.h"
#import "IMSessionSetIsMassModePush.h"

#import "VoteClosePush.h"


@implementation AKIMManager (Message)

+(NSDictionary*)messageMapping
{
    return @{
             //heartbeat
             @"heartbeat":              @"IMHeartBeatNotify",
             //session
             @"login.success":          @"IMLoginSuccessPush",
             @"user.error":             @"IMUserErrorPush",
             @"session.kick":           @"IMSessionKickPush",
             @"session.setIsMassMode":  @"IMSessionSetIsMassModePush",
             //room
             @"room.say":               @"IMRoomSayMessage",
             @"room.said":              @"IMRoomSaidPush",
             @"room.joined":            @"IMRoomJoinedPush",
             @"room.renqiChange":       @"IMRoomRenqiChangePush",
             @"room.liveoffline":       @"IMRoomLiveofflinePush",
             @"room.setRM":             @"IMRoomSetRMPush",
             @"room.join":              @"IMRoomJoinMessage",
             @"room.leave":             @"IMRoomLeaveMessage",
             @"room.getUIDs":           @"IMRoomGetUIDsMessage",
             @"room.get_uds":            @"IMRoomGetUDsMessage",
             @"room.whereami":          @"IMRoomWhereAmIMessage",
             @"room.setNuts":           @"IMRoomSetNutsPush",
             @"room.love":              @"IMRoomLoveMessage",
             @"room.loved":             @"IMRoomLovedPush",
             @"room.gived":             @"IMRoomGivedPush",
             @"room.gived2":            @"IMRoomGived2Push",
             @"room.broadcast":         @"IMRoomBroadCastMessage",
             @"room.broadcasted":       @"IMRoomBroadCastedPush",
             @"room.host_broadcast":    @"IMRoomHostBroadcastMessage",
             @"room.host_broadcasted":  @"IMRoomHostBroadcastedPush",
             @"room.muted":             @"IMRoomMutedPush",
             @"live.ping":              @"IMLivePingMessage",
             //IM
             @"im.say":                 @"IMSayMessage",
             @"im.said":                @"IMSaidPush",
             @"im.get":                 @"IMGetMessage",
             @"im.getMaxIndices":       @"IMGetMaxIndicesMessage",
             @"im.get_unread_list":      @"IMGetUnreadList",
             @"im.clear_unread_num":    @"IMClearUnreadNumMessage",
             @"im.follow_updated":      @"IMFollowUpdated",
             @"broadcast.notice_updated": @"IMBroadcastNoticeUpdatedPush",
             //updateUserInfoNotic
             @"broadcast.userinfo_updated":@"IMUserInfoUpdatedPush",
             
             REQ_IM_REVOKE:              @"IMRevokeMessage",
             NOT_IM_REVOKED:             @"IMRevokedPush",
             REQ_IM_REMOVE:              @"IMRemoveMessage",
             //activity_vote
             @"vote.publish":           @"VotePublishPush",
             @"vote.update":            @"VoteUpdatePush",
             @"vote.close":            @"VoteClosePush",
             //节目
             @"room.php_broadcasted":   @"PhpBroadcastedPush",
             @"room.show_renqi_updated":@"ShowRenQiUpdatePush",
             @"broadcast.announced":    @"BroadcastAnnouncedPush",//飞屏
             @"roomhot.updated":@"IMRoomHotUpdatePush",//热度推送,
             //游戏_猜数字
             @"numgame.step_changed":@"NumgameStateChangedPush",
             @"numgame.result_changed":@"NumgameResultChangedPush",
             @"numgame.jackpot_changed":@"NumgameJackpotChangedPush",
             @"numgame.winners_changed":@"NumgameWinnerChangePush",
             //热度礼物
             @"room.send_hot_gift":@"RoomSendHotGift"
             };
}

-(void)messageRegister
{
    NSDictionary* mdic = [AKIMManager messageMapping];
    [mdic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [self registerMessageClass:key className:obj];
        
    }];
    
    
}


-(void)registerMessageClass:(NSString*)cmd className:(NSString*)className;
{
    
    [self.messageClassPool setValue:className forKey:cmd];
}

-(id<IMMessageDelegate>)createMessage:(NSString*)cmd
{
    NSString* className = [self.messageClassPool objectForKey:cmd];
    Class aClass = NSClassFromString(className);
    if( [aClass isSubclassOfClass:[IMMessage class]]){
        return aClass.new;
    }
    
    // NSAssert(aClass != nil, @"NO Message Object Create,Register Message %@ First !",cmd);
    return nil;
    
}

@end
