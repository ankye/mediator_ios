//
//  AKDBManager+UserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserDetail.h"
#import "UserModuleDefine.h"
#import "TLDBUserDetailSQL.h"
#import "AKUserDetail.h"

@implementation AKDBManager (UserDetail)


AKDB_CREATE_TABLE_IMPL(user_detail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_CREATE_TABLE_USERDETAIL)

AKDB_INSERT_OR_UPDATE_IMPL(user_detail,AKUserDetail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_INSERT_OR_UPDATE_USERDETAIL)

AKDB_UPDATE_BY_ID_IMPL(user_detail,@"uid",KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL)

AKDB_QUERY_ROWS_BY_ID_IMPL(user_detail,AKUserDetail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_SELECT_USERDETAIL_ROWS)

AKDB_QUERY_ROW_BY_ID_IMPL(user_detail,AKUserDetail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_SELECT_USERDETAIL_ROW)

AKDB_DELETE_BY_ID_IMPL(user_detail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_DELETE_USERDETAIL)

//
////创建用户表
//- (BOOL)userDetail_createTable
//{
//    return [self createTableWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSql:SQL_CREATE_TABLE_USERDETAIL];
//    
//    
//    
//}
//
////插入或者更新用户数据
//- (BOOL)userDetail_insertOrUpdate:(id<AKUserDetailProtocol,AKDataObjectProtocol>)user
//{
//    return [self insertOrUpdate:user withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSqlFormat:SQL_INSERT_OR_UPDATE_USERDETAIL];
//    
//}
//
//
//
//-(BOOL)userDetail_updateByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values
//{
//
//    
//    return [self updateByID:@"uid" withKeyValue:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withAttributes:attributes withValues:values];
//}
//
///**
// *  查询多个用户详细信息
// */
//- (NSArray *)userDetail_queryRowsByID:(NSArray *)uids
//{
//   
//    return [self queryRowsByID:uids withModel:[AKUserDetail class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSqlFormat:SQL_SELECT_USERDETAIL_ROWS];
//}
//
////查询单条User详细信息
//-(id<AKUserDetailProtocol>)userDetail_queryRowByID:(NSString*)uid
//{
//  
//    return (id<AKUserDetailProtocol>)[self queryRowByID:uid withModel:[AKUserDetail class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSqlFormat:SQL_SELECT_USERDETAIL_ROW];
//    
//}
//
///**
// *  删除单条会话
// */
//- (BOOL)userDetail_deleteByID:(NSString *)uid
//{
//
//    return [self deleteByID:uid withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withSqlFormat:SQL_DELETE_USERDETAIL];
//    
//}
//




@end
