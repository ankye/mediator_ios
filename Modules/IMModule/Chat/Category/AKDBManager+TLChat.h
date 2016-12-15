//
//  AKDBManager+TLChat.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "TLEmojiGroup.h"
#import "TLMessage.h"
#import "TLGroup.h"
#import "TLConversation.h"

@interface AKDBManager (TLChat)

//会话
/////////////////////////////


- (BOOL)createConversationTable;
/**
 *  新的会话（未读）
 */
- (BOOL)addConversationByUid:(NSString *)uid fid:(NSString *)fid type:(NSInteger)type date:(NSDate *)date;

//查询单条conversion
-(TLConversation*)conversationMessageByUid:(NSString*)uid fid:(NSString*)fid;

/**
 *  更新会话
 */
- (BOOL)updateConversation:(NSString*)uid withConversation:(TLConversation*)conv;


/**
 *  查询所有会话
 */
- (NSArray *)conversationsByUid:(NSString *)uid;

/**
 *  未读消息数
 */
- (NSInteger)unreadMessageByUid:(NSString *)uid fid:(NSString *)fid;

/**
 *  删除单条会话
 */
- (BOOL)deleteConversationByUid:(NSString *)uid fid:(NSString *)fid;

/**
 *  删除用户的所有会话
 */
- (BOOL)deleteConversationsByUid:(NSString *)uid;

///////////////
//GROUP
////

//- (BOOL)createGroupTable;
//
//- (BOOL)updateGroupsData:(NSArray *)groupData
//                  forUid:(NSString *)uid;
//
//- (BOOL)addGroup:(TLGroup *)group forUid:(NSString *)uid;
//
//
//- (NSMutableArray *)groupsDataByUid:(NSString *)uid;
//
//- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid;
//


//chat///////////////
//创建聊天表
- (BOOL)createChatMessageTable;

/**
 *  添加消息记录
 */
- (BOOL)addMessage:(TLMessage *)message;

#pragma mark - 查询
/**
 *  获取与某个好友的聊天记录
 */
- (void)messagesByUserID:(NSString *)userID
               partnerID:(NSString *)partnerID
                fromDate:(NSDate *)date
                   count:(NSUInteger)count
                complete:(void (^)(NSArray *data, BOOL hasMore))complete;

/**
 *  获取与某个好友/讨论组的聊天文件
 */
- (NSArray *)chatFilesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;

/**
 *  获取与某个好友/讨论组的聊天图片及视频
 */
- (NSArray *)chatImagesAndVideosByUserID:(NSString *)userID partnerID:(NSString *)partnerID;

/**
 *  最后一条聊天记录（消息页用）
 */
- (TLMessage *)lastMessageByUserID:(NSString *)userID partnerID:(NSString *)partnerID;

#pragma mark - 删除
/**
 *  删除单条消息
 */
- (BOOL)deleteMessageByMessageID:(NSString *)messageID;

/**
 *  删除与某个好友/讨论组的所有聊天记录
 */
- (BOOL)deleteMessagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;

/**
 *  删除用户的所有聊天记录
 */
- (BOOL)deleteMessagesByUserID:(NSString *)userID;


///////////////////////////
//创建表情表
- (BOOL)createExpressionGroupTable;
/**
 *  添加表情包
 */
- (BOOL)addExpressionGroup:(TLEmojiGroup *)group forUid:(NSString *)uid;

/**
 *  查询所有表情包
 */
- (NSArray *)expressionGroupsByUid:(NSString *)uid;

/**
 *  删除表情包
 */
- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid;

/**
 *  拥有某表情包的用户数
 */
- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid;



@end
