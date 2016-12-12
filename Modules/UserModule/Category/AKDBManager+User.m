//
//  AKDBManager+User.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+User.h"
#import "TLDBUserSQL.h"




@implementation AKDBManager (User)

//创建用户表
- (BOOL)createTableUser
{
    return [self createTableWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSql:SQL_CREATE_TABLE_USER];
    
 
    
}

//插入或者更新用户数据
- (BOOL)insertOrUpdateUser:(id<AKUserProtocol>)user
{
    NSString *sqlString = [NSString stringWithFormat:SQL_INSERT_OR_UPDATE_USER, TABLE_NAME_USER];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        user.uid,
                        user.usernum,
                        user.username,
                        user.nickname,
                        user.avatar,
                        user.avatarHD,
                        user.avatarPath,
                        user.remarkName,
                        user.money,
                        user.coin,
                        user.lastNicknameModifyTime,
                        user.lastLoginTime,
                        user.lastPayTime,
                        user.pinyin,
                        user.pinyinInitial,
                        @"", @"", @"", @"", @"", nil];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;

}

-(BOOL)updateUserByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values
{
     return [self updateByID:@"uid" withKeyValue:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withAttributes:attributes withValues:values];
    
}

/**
 *  查询多个用户信息
 */
- (NSArray *)queryUsersByID:(NSArray *)uids
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString* allUids =  [uids componentsJoinedByString:@","];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_USER_ROWS, TABLE_NAME_USER, allUids];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            id<AKUserProtocol> user = [self resultSetToBaseUser:retSet];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

//查询单条User信息
-(id<AKUserProtocol>)queryUserByID:(NSString*)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_USER_ROW, TABLE_NAME_USER, uid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    __block id<AKUserProtocol> user = nil;
    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            user = [self resultSetToBaseUser:retSet];
        }
        [retSet close];
    }];
    return user;
}

/**
 *  删除单条会话
 */
- (BOOL)deleteUserByID:(NSString *)uid
{
    return [self deleteByID:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSqlFormat:SQL_DELETE_USER];
}


-(id<AKUserProtocol>)resultSetToBaseUser:(FMResultSet*)retSet
{
    AKUser *user = [[AKUser alloc] init];
    user.uid =  [retSet stringForColumn:@"uid"];
    user.usernum =  [retSet stringForColumn:@"usernum"];
    user.username =  [retSet stringForColumn:@"username"];
    user.nickname =  [retSet stringForColumn:@"nickname"];
    user.avatar =  [retSet stringForColumn:@"avatar"];
    user.avatarHD =  [retSet stringForColumn:@"avatarHD"];
    user.avatarPath =  [retSet stringForColumn:@"avatarPath"];
    user.remarkName =  [retSet stringForColumn:@"remarkName"];
    user.money =  @([retSet doubleForColumn:@"money"]);
    user.coin =  @([retSet doubleForColumn:@"coin"]);
    user.lastNicknameModifyTime =  @([retSet intForColumn:@"lastNicknameModifyTime"]);
    user.lastLoginTime =  @([retSet intForColumn:@"lastLoginTime"]);
    user.lastPayTime =  @([retSet intForColumn:@"lastPayTime"]);
    user.pinyin =  [retSet stringForColumn:@"pinyin"];
    user.pinyinInitial =  [retSet stringForColumn:@"pinyinInitial"];
    return user;
}

@end
