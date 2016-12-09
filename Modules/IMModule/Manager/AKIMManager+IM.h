//
//  IMManager+IM
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager.h"

@interface AKIMManager (IM)

#pragma mark -发送消息给指定用户。
- (int)imSay:(NSString *)to_uid content:(NSString*)content withComplete:(imRequestCompletion)complete;

#pragma mark -获取聊天记录
- (void)imGet:(NSString *)from_uid startIndex:(int)startIndex endIndex:(int)endIndex withComplete:(imRequestCompletion)complete;

#pragma mark -获取离线期间和我说话的聊天记录索引。
- (void)imGetMaxIndices:(imRequestCompletion)complete;

#pragma mark -获取用户未读消息数及最新消息
- (void)imGetUnreadList:(imRequestCompletion)complete;

#pragma mark -设置聊天记录为已读
- (void)imClearUnreadNum:(NSString *)chatUid Flag:(NSNumber *)flag withComplete:(imRequestCompletion)complete;

#pragma mark -聊天记录回退
- (void)imRevoke:(NSString *)uid Index:(NSNumber *)index withComplete:(imRequestCompletion)complete;

#pragma mark -删除聊天信息
- (void)imRemove:(NSString *)uid Start:(NSNumber *)startIndex To:(NSNumber *)toIndex withComplete:(imRequestCompletion)complete;

@end
