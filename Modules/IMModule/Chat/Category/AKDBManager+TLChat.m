//
//  AKDBManager+TLChat.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+TLChat.h"
#import "TLDBExpressionSQL.h"

#define KAK_TLCHAT_DBNAME @"TLChat"


@implementation AKDBManager (TLChat)


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
