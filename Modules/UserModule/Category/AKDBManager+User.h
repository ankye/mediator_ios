//
//  AKDBManager+User.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "UserModuleDefine.h"
#import "AKDBManager.h"
#import "TLDBUserSQL.h"


@interface AKDBManager (User)

AKDB_CREATE_TABLE_INTR(user)

AKDB_INSERT_OR_UPDATE_INTR(user,AKUser)

AKDB_UPDATE_BY_ID_INTR(user)

AKDB_QUERY_ROWS_BY_ID_INTR(user)

AKDB_QUERY_ROW_BY_ID_INTR(user,AKUser)

AKDB_DELETE_BY_ID_INTR(user)


///**
// 创建用户表
//
// @return YES or NO
// */
//- (BOOL)user_createTable;
//
//- (BOOL)user_insertOrUpdate:(AKUser*)user;
//
//- (BOOL)user_updateByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values;
//
///**
// *  查询多个UserProtocol用户信息
// */
//- (NSArray *)user_queryRowsByID:(NSArray *)uids;
//
////查询单条UserProtocol信息
//- (AKUser*)user_queryRowByID:(NSString*)uid;
//
///**
// *  删除单条会话
// */
//- (BOOL)user_deleteByID:(NSString *)uid;
@end
