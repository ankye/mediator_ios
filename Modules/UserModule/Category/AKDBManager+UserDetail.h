//
//  AKDBManager+UserDetail.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "TLDBUserDetailSQL.h"
#import "AKUserDetail.h"

@interface AKDBManager (UserDetail)


AKDB_CREATE_TABLE_INTR(user_detail)

AKDB_INSERT_OR_UPDATE_INTR(user_detail,AKUserDetail)

AKDB_UPDATE_BY_ID_INTR(user_detail)

AKDB_QUERY_ROWS_BY_ID_INTR(user_detail)

AKDB_QUERY_ROW_BY_ID_INTR(user_detail, AKUserDetail )

AKDB_DELETE_BY_ID_INTR(user_detail)



////创建用户Detail表
//- (BOOL)userDetail_createTable;
//
////插入或者更新用户Detail数据
//- (BOOL)userDetail_insertOrUpdate:(id<AKUserDetailProtocol,AKDataObjectProtocol>)user;
//
////更新用户detail信息
//-(BOOL)userDetail_updateByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values;
//
///**
// *  查询多个用户详细信息
// */
//- (NSArray *)userDetail_queryRowsByID:(NSArray *)uids;
//
////查询单条User详细信息
//-(id<AKUserDetailProtocol>)userDetail_queryRowByID:(NSString*)uid;
//
///**
// *  删除单条用户详情
// */
//- (BOOL)userDetail_deleteByID:(NSString *)uid;
//

@end
