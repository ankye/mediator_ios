//
//  AKDBManager+User.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+User.h"

#import "AKDBManager+UserDetail.h"

@implementation AKDBManager (User)



AKDB_CREATE_TABLE_IMPL(user,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_CREATE_TABLE_USER)

AKDB_INSERT_OR_UPDATE_IMPL(user,AKUser,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_INSERT_OR_UPDATE_USER)

AKDB_UPDATE_BY_ID_IMPL(user,@"uid",KAK_TLUSER_DBNAME,TABLE_NAME_USER)

AKDB_QUERY_ROWS_BY_ID_IMPL(user,AKUser,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_SELECT_USER_ROWS)

AKDB_QUERY_ROW_BY_ID_IMPL(user,AKUser,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_SELECT_USER_ROW)

AKDB_DELETE_BY_ID_IMPL(user,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_DELETE_USER)


////创建用户表
//- (BOOL)user_createTable
//{
//    return [self createTableWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSql:SQL_CREATE_TABLE_USER];
//    
// 
//    
//}
//
////插入或者更新用户数据
//- (BOOL)user_insertOrUpdate:(AKUser*)user
//{
//  
//    return [self insertOrUpdate:user withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSqlFormat:SQL_INSERT_OR_UPDATE_USER];
//}
//
//-(BOOL)user_updateByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values
//{
//     return [self updateByID:@"uid" withKeyValue:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withAttributes:attributes withValues:values];
//    
//}
//
///**
// *  查询多个用户信息
// */
//- (NSArray *)user_queryRowsByID:(NSArray *)uids
//{
//  
//    return [self queryRowsByID:uids withModel:[AKUser class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSqlFormat:SQL_SELECT_USER_ROWS];
//}
//
////查询单条User信息
//-(AKUser*)user_queryRowByID:(NSString*)uid
//{
//    return (AKUser*)[self queryRowByID:uid withModel:[AKUser class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSqlFormat:SQL_SELECT_USER_ROW];
//    
//}
//
///**
// *  删除单条会话
// */
//- (BOOL)user_deleteByID:(NSString *)uid
//{
//    return [self deleteByID:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withSqlFormat:SQL_DELETE_USER];
//}
//


@end
