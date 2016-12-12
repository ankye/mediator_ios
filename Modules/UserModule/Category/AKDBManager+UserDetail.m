//
//  AKDBManager+UserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserDetail.h"
#import "AKDBManager+User.h"
#import "TLDBUserDetailSQL.h"
#import "AKUserDetail.h"

@implementation AKDBManager (UserDetail)


//创建用户表
- (BOOL)createTableUserDetail
{
    return [self createTableWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSql:SQL_CREATE_TABLE_USERDETAIL];
    
    
    
}

//插入或者更新用户数据
- (BOOL)insertOrUpdateUserDetail:(id<AKUserDetailProtocol>)user
{
    
    
    NSString *sqlString = [NSString stringWithFormat:SQL_INSERT_OR_UPDATE_USERDETAIL, TABLE_NAME_USERDETAIL];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        user.uid,
                        @(user.sex),
                        user.location,
                        user.phoneNumber,
                        user.qqNumber,
                        user.email,
                        [user.albumArray componentsJoinedByString:@","],
                        user.motto,
                        user.momentsWallURL,
                        user.address,
                        user.birthday,
                        user.hometown,
                        @(user.latitude),
                        @(user.longitude),
                        user.remarkInfo,
                        user.remarkImagePath,
                        user.remarkImageURL,
                        [user.tags componentsJoinedByString:@","],
                        @"", @"", @"", @"", @"", nil];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
    
}



-(BOOL)updateUserDetailByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values
{

    
    return [self updateByID:@"uid" withKeyValue:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withAttributes:attributes withValues:values];
}

/**
 *  查询多个用户详细信息
 */
- (NSArray *)queryUserDetailsByID:(NSArray *)uids
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString* allUids =  [uids componentsJoinedByString:@","];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_USERDETAIL_ROWS, TABLE_NAME_USERDETAIL, allUids];
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            id<AKUserDetailProtocol> user = [self resultSetToUserDetail:retSet];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

//查询单条User详细信息
-(id<AKUserDetailProtocol>)queryUserDetailByID:(NSString*)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_USERDETAIL_ROW, TABLE_NAME_USERDETAIL, uid];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    __block id<AKUserDetailProtocol> user = nil;
    
    [self excuteQuery:queue withSql:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            user = [self resultSetToUserDetail:retSet];
        }
        [retSet close];
    }];
    return user;
}

/**
 *  删除单条会话
 */
- (BOOL)deleteUserDetailByID:(NSString *)uid
{

    return [self deleteByID:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSqlFormat:SQL_DELETE_USERDETAIL];
    
}


-(id<AKUserDetailProtocol>)resultSetToUserDetail:(FMResultSet*)retSet
{
    AKUserDetail *user = [[AKUserDetail alloc] init];
    
    user.uid =  [retSet stringForColumn:@"uid"];
    user.sex =  [retSet intForColumn:@"sex"];
    user.location =  [retSet stringForColumn:@"location"];
    user.phoneNumber =  [retSet stringForColumn:@"phoneNumber"];
    user.qqNumber =  [retSet stringForColumn:@"qqNumber"];
    user.email =  [retSet stringForColumn:@"email"];
    NSArray* arr = [[retSet stringForColumn:@"albumArray"] componentsSeparatedByString:@","];
    user.albumArray = [[NSMutableArray alloc] initWithArray:arr];
    user.motto =  [retSet stringForColumn:@"motto"];
    user.momentsWallURL =  [retSet stringForColumn:@"momentsWallURL"];
    user.address =  [retSet stringForColumn:@"address"];
    user.birthday =  [retSet stringForColumn:@"birthday"];
    user.hometown = [retSet stringForColumn:@"hometown"];
    user.latitude =  [retSet doubleForColumn:@"latitude"];
    user.longitude =  [retSet doubleForColumn:@"longitude"];
    user.remarkInfo =  [retSet stringForColumn:@"remarkInfo"];
    user.remarkImagePath = [retSet stringForColumn:@"remarkImagePath"];
    user.remarkImageURL =  [retSet stringForColumn:@"remarkImageURL"];
    NSArray* tags =  [[retSet stringForColumn:@"tags"] componentsSeparatedByString:@","];
    user.tags = [[NSMutableArray alloc] initWithArray:tags];

    return user;
}




@end
