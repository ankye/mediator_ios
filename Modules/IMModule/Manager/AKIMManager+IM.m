//
//  IMManager+IM
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager+IM.h"
#import "AKIMManager+Message.h"
//IM
#import "IMSaidPush.h"
#import "IMSayMessage.h"
#import "IMGetMessage.h"
#import "IMGetMaxIndicesMessage.h"
#import "IMGetUnreadList.h"
#import "IMClearUnreadNumMessage.h"
#import "IMRevokeMessage.h"
#import "IMRevokedPush.h"
#import "IMRemoveMessage.h"


@implementation AKIMManager (IM)

#pragma mark -发送消息给指定用户。
- (int)imSay:(NSString *)to_uid content:(NSString*)content withComplete:(imRequestCompletion)complete
{

    NSAssert(to_uid != nil, @"imSay to_uid not nil");
    NSAssert(content != nil, @"imSay content not nil");
    
    IMSayMessage* message = (IMSayMessage*)[self createMessage:@"im.say"];
    message.to_uid = to_uid;
    message.content = content;
     message.complete = complete;
    [self postMessage:message];
    return [message getRequestID];
}

#pragma mark -获取聊天记录
- (void)imGet:(NSString *)from_uid startIndex:(int)startIndex endIndex:(int)endIndex withComplete:(imRequestCompletion)complete
{
    NSAssert(from_uid != nil, @"imSay to_uid not nil");
    IMGetMessage* message = (IMGetMessage*)[self createMessage:@"im.get"];
    message.from_uid = from_uid;
    message.startIndex = startIndex;
    message.endIndex = endIndex;
     message.complete = complete;
    [self postMessage:message];
}

#pragma mark -获取离线期间和我说话的聊天记录索引。
- (void)imGetMaxIndices:(imRequestCompletion)complete
{
//    return;
    IMGetMaxIndicesMessage* message = (IMGetMaxIndicesMessage*)[self createMessage:@"im.getMaxIndices"];
    message.complete = complete;
    [self postMessage:message];
}

#pragma mark -获取用户未读消息数及最新消息
- (void)imGetUnreadList:(imRequestCompletion)complete
{
    IMGetUnreadList *message = (IMGetUnreadList *)[self createMessage:REQ_IM_GETUNREADLIST];
     message.complete = complete;
    [self postMessage:message];
}

#pragma mark -设置聊天记录为已读
- (void)imClearUnreadNum:(NSString *)chatUid Flag:(NSNumber *)flag withComplete:(imRequestCompletion)complete
{
    IMClearUnreadNumMessage *message = (IMClearUnreadNumMessage *)[self createMessage:REQ_IM_CLEARUNREADNUM];
    message.fromUid = chatUid;
    message.flag    = flag;
     message.complete = complete;
    [self postMessage:message];
}

#pragma mark -回退某条聊天记录
- (void)imRevoke:(NSString *)uid Index:(NSNumber *)index withComplete:(imRequestCompletion)complete
{
    IMRevokeMessage *message = (IMRevokeMessage *)[self createMessage:REQ_IM_REVOKE];
    message.toUid       = uid;
    message.revokeIndex = index;
     message.complete = complete;
    [self postMessage:message];
}

#pragma mark -删除聊天信息
- (void)imRemove:(NSString *)uid Start:(NSNumber *)startIndex To:(NSNumber *)toIndex withComplete:(imRequestCompletion)complete
{
    IMRemoveMessage *message = (IMRemoveMessage *)[self createMessage:REQ_IM_REMOVE];
    message.uid = uid;
    message.startIndex  = startIndex;
    message.endIndex    = toIndex;
     message.complete = complete;
    [self postMessage:message];
}

@end
