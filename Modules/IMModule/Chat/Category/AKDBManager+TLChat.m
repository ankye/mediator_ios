//
//  AKDBManager+TLChat.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+TLChat.h"
#import "TLDBExpressionSQL.h"
#import "TLDBMessageStoreSQL.h"
#import "TLDBConversationSQL.h"
#import "TLConversation.h"
#import "NSDate+Utilities.h"
#import "TLDBGroupSQL.h"

#define KAK_TLCHAT_DBNAME @"TLChat"


@implementation AKDBManager (TLChat)

//会话

//创建会话表
- (BOOL)createConversationTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_CONV_TABLE, CONV_TABLE_NAME];
     FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    return [self createTable:queue withTableName:CONV_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addConversationByUid:(NSString *)uid fid:(NSString *)fid type:(NSInteger)type date:(NSDate *)date
{
    
    
    TLConversation* conv = [self conversationMessageByUid:uid fid:fid];
    NSInteger unreadCount = conv.unreadCount + 1;
    NSInteger maxIndex = conv.maxIndex +1;
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CONV, CONV_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        uid,
                        fid,
                        [NSNumber numberWithInteger:type],
                        TLTimeStamp(date),
                        [NSNumber numberWithInteger:unreadCount],
                        [NSNumber numberWithInteger:maxIndex],
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
}

/**
 *  更新会话
 */
- (BOOL)updateConversation:(NSString*)uid withConversation:(TLConversation*)conv
{
   
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CONV, CONV_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        uid,
                        conv.partnerID,
                        [NSNumber numberWithInteger:conv.convType],
                        TLTimeStamp(conv.date),
                        [NSNumber numberWithInteger:conv.unreadCount],
                        [NSNumber numberWithInteger:conv.maxIndex],
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
}

/**
 *  查询所有会话
 */
- (NSArray *)conversationsByUid:(NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_CONVS, CONV_TABLE_NAME, uid];
     FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLConversation *conversation = [[TLConversation alloc] init];
            conversation.partnerID = [retSet stringForColumn:@"fid"];
            conversation.convType = [retSet intForColumn:@"conv_type"];
            NSString *dateString = [retSet stringForColumn:@"date"];
            conversation.date = [NSDate dateWithTimeIntervalSince1970:dateString.doubleValue];
            conversation.unreadCount = [retSet intForColumn:@"unread_count"];
            conversation.maxIndex = [retSet intForColumn:@"max_index"];
            [data addObject:conversation];
        }
        [retSet close];
    }];
    
    // 获取conv对应的msg
    for (TLConversation *conversation in data) {
        TLMessage * message = [self lastMessageByUserID:uid partnerID:conversation.partnerID];
        if (message) {
            conversation.content = [message conversationContent];
            conversation.date = message.date;
        }
    }
    
    return data;
}

//查询单条conversion
-(TLConversation*)conversationMessageByUid:(NSString*)uid fid:(NSString*)fid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CONV, CONV_TABLE_NAME, uid, fid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    __block TLConversation *conversation = nil;

    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            conversation = [[TLConversation alloc] init];
            conversation.partnerID = [retSet stringForColumn:@"fid"];
            conversation.convType = [retSet intForColumn:@"conv_type"];
            NSString *dateString = [retSet stringForColumn:@"date"];
            conversation.date = [NSDate dateWithTimeIntervalSince1970:dateString.doubleValue];
            conversation.unreadCount = [retSet intForColumn:@"unread_count"];
            conversation.maxIndex = [retSet intForColumn:@"max_index"];
        }
        [retSet close];
    }];
    return conversation;
}

- (NSInteger)unreadMessageByUid:(NSString *)uid fid:(NSString *)fid
{
    __block NSInteger unreadCount = 0;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CONV_UNREAD, CONV_TABLE_NAME, uid, fid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            unreadCount = [retSet intForColumn:@"unread_count"];
        }
        [retSet close];
    }];
    return unreadCount;
}

/**
 *  删除单条会话
 */
- (BOOL)deleteConversationByUid:(NSString *)uid fid:(NSString *)fid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CONV, CONV_TABLE_NAME, uid, fid];
     FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}

/**
 *  删除用户的所有会话
 */
- (BOOL)deleteConversationsByUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_CONVS, CONV_TABLE_NAME, uid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}

//////GROUP

- (BOOL)createGroupTable
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_GROUPS_TABLE, GROUPS_TABLE_NAME];
    BOOL ok = [self createTable:queue withTableName:GROUPS_TABLE_NAME withSQL:sqlString];
    if (ok) {
        sqlString = [NSString stringWithFormat:SQL_CREATE_GROUP_MEMBERS_TABLE, GROUP_MEMBER_TABLE_NAMGE];
        ok = [self createTable:queue withTableName:GROUP_MEMBER_TABLE_NAMGE withSQL:sqlString];
    }
    return ok;
}

- (BOOL)addGroup:(TLGroup *)group forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_GROUP, GROUPS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        TLNoNilString(uid),
                        TLNoNilString(group.groupID),
                        TLNoNilString(group.groupName),
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    if (ok) {
        // 将通讯录成员插入数据库
        ok = [self addGroupMembers:group.users forUid:uid andGid:group.groupID];
    }
    return ok;
}

- (BOOL)updateGroupsData:(NSArray *)groupData forUid:(NSString *)uid
{
    NSArray *oldData = [self groupsDataByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (TLGroup *group in groupData) {
            [newDataHash setValue:@"YES" forKey:group.groupID];
        }
        for (TLGroup *group in oldData) {
            if ([newDataHash objectForKey:group.groupID] == nil) {
                BOOL ok = [self deleteGroupByGid:group.groupID forUid:uid];
                if (!ok) {
                    DDLogError(@"DBError: 删除过期讨论组失败！");
                }
            }
        }
    }
    
    // 将数据插入数据库
    for (TLGroup *group in groupData) {
        BOOL ok = [self addGroup:group forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}


- (NSMutableArray *)groupsDataByUid:(NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_GROUPS, GROUPS_TABLE_NAME, uid];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLGroup *group = [[TLGroup alloc] init];
            group.groupID = [retSet stringForColumn:@"gid"];
            group.groupName = [retSet stringForColumn:@"name"];
            [data addObject:group];
        }
        [retSet close];
    }];
    
    // 获取讨论组成员
    for (TLGroup *group in data) {
        group.users = [self groupMembersForUid:uid andGid:group.groupID];
    }
    
    return data;
}

- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_GROUP, GROUPS_TABLE_NAME, uid, gid];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}


#pragma mark - # Group Members
- (BOOL)addGroupMember:(TLUser *)user forUid:(NSString *)uid andGid:(NSString *)gid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        TLNoNilString(uid),
                        TLNoNilString(gid),
                        TLNoNilString(user.userID),
                        TLNoNilString(user.username),
                        TLNoNilString(user.nikeName),
                        TLNoNilString(user.avatarURL),
                        TLNoNilString(user.remarkName),
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)addGroupMembers:(NSArray *)users forUid:(NSString *)uid andGid:(NSString *)gid
{
    NSArray *oldData = [self groupMembersForUid:uid andGid:gid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (TLUser *user in users) {
            [newDataHash setValue:@"YES" forKey:user.userID];
        }
        for (TLUser *user in oldData) {
            if ([newDataHash objectForKey:user.userID] == nil) {
                BOOL ok = [self deleteGroupMemberForUid:uid gid:gid andFid:user.userID];
                if (!ok) {
                    DDLogError(@"DBError: 删除过期好友失败");
                }
            }
        }
    }
    for (TLUser *user in users) {
        BOOL ok = [self addGroupMember:user forUid:uid andGid:gid];
        if (!ok) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)groupMembersForUid:(NSString *)uid andGid:(NSString *)gid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_GROUP_MEMBERS, GROUP_MEMBER_TABLE_NAMGE, uid];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLUser *user = [[TLUser alloc] init];
            user.userID = [retSet stringForColumn:@"uid"];
            user.username = [retSet stringForColumn:@"username"];
            user.nikeName = [retSet stringForColumn:@"nikename"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
            user.remarkName = [retSet stringForColumn:@"remark"];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

- (BOOL)deleteGroupMemberForUid:(NSString *)uid gid:(NSString *)gid andFid:(NSString *)fid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE, uid, gid, fid];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}


///////

/////////////////////////////////
//创建聊天表
- (BOOL)createChatMessageTable
{
     FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_MESSAGE_TABLE, MESSAGE_TABLE_NAME];
    return [self createTable:queue withTableName:MESSAGE_TABLE_NAME withSQL:sqlString];
}

- (BOOL)addMessage:(TLMessage *)message
{
    if (message == nil || message.messageID == nil || message.userID == nil || (message.friendID == nil && message.groupID == nil)) {
        return NO;
    }
    
    NSString *fid = @"";
    NSString *subfid;
    if (message.partnerType == TLPartnerTypeUser) {
        fid = message.friendID;
    }
    else {
        fid = message.groupID;
        subfid = message.friendID;
    }
    
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_MESSAGE, MESSAGE_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        message.messageID,
                        message.userID,
                        fid,
                        TLNoNilString(subfid),
                        TLTimeStamp(message.date),
                        [NSNumber numberWithInteger:message.partnerType],
                        [NSNumber numberWithInteger:message.ownerTyper],
                        [NSNumber numberWithInteger:message.messageType],
                        [message.content mj_JSONString],
                        [NSNumber numberWithInteger:message.sendState],
                        [NSNumber numberWithInteger:message.readState],
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
}

- (void)messagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID fromDate:(NSDate *)date count:(NSUInteger)count complete:(void (^)(NSArray *, BOOL))complete
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:
                           SQL_SELECT_MESSAGES_PAGE,
                           MESSAGE_TABLE_NAME,
                           userID,
                           partnerID,
                           [NSString stringWithFormat:@"%lf", date.timeIntervalSince1970],
                           (long)(count + 1)];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLMessage *message = [self p_createDBMessageByFMResultSet:retSet];
            [data insertObject:message atIndex:0];
        }
        [retSet close];
    }];
    
    BOOL hasMore = NO;
    if (data.count == count + 1) {
        hasMore = YES;
        [data removeObjectAtIndex:0];
    }
    complete(data, hasMore);
}

- (NSArray *)chatFilesByUserID:(NSString *)userID partnerID:(NSString *)partnerID
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHAT_FILES, MESSAGE_TABLE_NAME, userID, partnerID];
    
    __block NSDate *lastDate = [NSDate date];
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLMessage * message = [self p_createDBMessageByFMResultSet:retSet];
            if (([message.date isThisWeek] && [lastDate isThisWeek]) || (![message.date isThisWeek] && [lastDate isSameMonthAsDate:message.date])) {
                [array addObject:message];
            }
            else {
                lastDate = message.date;
                if (array.count > 0) {
                    [data addObject:array];
                }
                array = [[NSMutableArray alloc] initWithObjects:message, nil];
            }
        }
        if (array.count > 0) {
            [data addObject:array];
        }
        [retSet close];
    }];
    return data;
}

- (NSArray *)chatImagesAndVideosByUserID:(NSString *)userID partnerID:(NSString *)partnerID
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHAT_MEDIA, MESSAGE_TABLE_NAME, userID, partnerID];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLMessage *message = [self p_createDBMessageByFMResultSet:retSet];
            [data addObject:message];
        }
        [retSet close];
    }];
    return data;
}

- (TLMessage *)lastMessageByUserID:(NSString *)userID partnerID:(NSString *)partnerID
{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_LAST_MESSAGE, MESSAGE_TABLE_NAME, MESSAGE_TABLE_NAME, userID, partnerID];
    __block TLMessage * message;
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            message = [self p_createDBMessageByFMResultSet:retSet];
        }
        [retSet close];
    }];
    return message;
}

- (BOOL)deleteMessageByMessageID:(NSString *)messageID
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_MESSAGE, MESSAGE_TABLE_NAME, messageID];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}

- (BOOL)deleteMessagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND_MESSAGES, MESSAGE_TABLE_NAME, userID, partnerID];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}

- (BOOL)deleteMessagesByUserID:(NSString *)userID
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_USER_MESSAGES, MESSAGE_TABLE_NAME, userID];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    BOOL ok = [self excuteSQL:queue withSql:sqlString, nil];
    return ok;
}

#pragma mark - Private Methods -
- (TLMessage *)p_createDBMessageByFMResultSet:(FMResultSet *)retSet
{
    TLMessageType type = [retSet intForColumn:@"msg_type"];
    TLMessage * message = [TLMessage createMessageByType:type];
    message.messageID = [retSet stringForColumn:@"msgid"];
    message.userID = [retSet stringForColumn:@"uid"];
    message.partnerType = [retSet intForColumn:@"partner_type"];
    if (message.partnerType == TLPartnerTypeGroup) {
        message.groupID = [retSet stringForColumn:@"fid"];
        message.friendID = [retSet stringForColumn:@"subfid"];
    }
    else {
        message.friendID = [retSet stringForColumn:@"fid"];
        message.groupID = [retSet stringForColumn:@"subfid"];
    }
    NSString *dateString = [retSet stringForColumn:@"date"];
    message.date = [NSDate dateWithTimeIntervalSince1970:dateString.doubleValue];
    message.ownerTyper = [retSet intForColumn:@"own_type"];
    NSString *content = [retSet stringForColumn:@"content"];
    message.content = [[NSMutableDictionary alloc] initWithDictionary:[content mj_JSONObject]];
    message.sendState = [retSet intForColumn:@"send_status"];
    message.readState = [retSet intForColumn:@"received_status"];
    return message;
}



//创建标签表
- (BOOL)createExpressionGroupTable
{
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];
    
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_EXP_GROUP_TABLE, EXP_GROUP_TABLE_NAME];
    BOOL ok = [AK_DB_MANAGER createTable:queue withTableName:EXP_GROUP_TABLE_NAME withSQL:sqlString];
    if (!ok) {
        return NO;
    }
    sqlString = [NSString stringWithFormat:SQL_CREATE_EXPS_TABLE, EXPS_TABLE_NAME];
    ok = [AK_DB_MANAGER createTable:queue withTableName:EXPS_TABLE_NAME withSQL:sqlString];
    return ok;
}


#pragma mark - # 表情组
- (BOOL)addExpressionGroup:(TLEmojiGroup *)group forUid:(NSString *)uid
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    // 添加表情包
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_EXP_GROUP, EXP_GROUP_TABLE_NAME];
    NSArray *arr = [NSArray arrayWithObjects:
                    uid,
                    group.groupID,
                    [NSNumber numberWithInteger:group.type],
                    TLNoNilString(group.groupName),
                    TLNoNilString(group.groupInfo),
                    TLNoNilString(group.groupDetailInfo),
                    [NSNumber numberWithInteger:group.count],
                    TLNoNilString(group.authID),
                    TLNoNilString(group.authName),
                    TLTimeStamp(group.date),
                    @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arr];
    if (!ok) {
        return NO;
    }
    // 添加表情包里的所有表情
    ok = [self addExpressions:group.data toGroupID:group.groupID];
    return ok;
}

- (NSArray *)expressionGroupsByUid:(NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    
    // 读取表情包信息
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLEmojiGroup *group = [[TLEmojiGroup alloc] init];
            group.groupID = [retSet stringForColumn:@"gid"];
            group.type = [retSet intForColumn:@"type"];
            group.groupName = [retSet stringForColumn:@"name"];
            group.groupInfo = [retSet stringForColumn:@"desc"];
            group.groupDetailInfo = [retSet stringForColumn:@"detail"];
            group.count = [retSet intForColumn:@"count"];
            group.authID = [retSet stringForColumn:@"auth_id"];
            group.authName = [retSet stringForColumn:@"auth_name"];
            group.status = TLEmojiGroupStatusDownloaded;
            [data addObject:group];
        }
        [retSet close];
    }];
    
    // 读取表情包的所有表情信息
    for (TLEmojiGroup *group in data) {
        group.data = [self expressionsForGroupID:group.groupID];
    }
    
    return data;
}

- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid, gid];
    return [self excuteSQL:queue withSql:sqlString, nil];
}

- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_COUNT_EXP_GROUP_USERS, EXP_GROUP_TABLE_NAME, gid];
    __block NSInteger count = 0;
    [queue inDatabase:^(FMDatabase *db) {
        count = [db intForQuery:sqlString];
    }];
    
    return count;
}

#pragma mark - # 表情
- (BOOL)addExpressions:(NSArray *)expressions toGroupID:(NSString *)groupID
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    for (TLEmoji *emoji in expressions) {
        NSString *sqlString = [NSString stringWithFormat:SQL_ADD_EXP, EXPS_TABLE_NAME];
        NSArray *arr = [NSArray arrayWithObjects:
                        groupID,
                        emoji.emojiID,
                        TLNoNilString(emoji.emojiName),
                        @"", @"", @"", @"", @"", nil];
        BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arr];
        if (!ok) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)expressionsForGroupID:(NSString *)groupID
{
    FMDatabaseQueue* queue = [self getQueue:KAK_TLCHAT_DBNAME];

    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_EXPS, EXPS_TABLE_NAME, groupID];
    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLEmoji *emoji = [[TLEmoji alloc] init];
            emoji.groupID = [retSet stringForColumn:@"gid"];
            emoji.emojiID = [retSet stringForColumn:@"eid"];
            emoji.emojiName = [retSet stringForColumn:@"name"];
            [data addObject:emoji];
        }
        [retSet close];
    }];
    
    return data;
}


@end
