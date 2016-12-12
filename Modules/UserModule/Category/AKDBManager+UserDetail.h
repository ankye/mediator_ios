//
//  AKDBManager+UserDetail.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"

@interface AKDBManager (UserDetail)


//创建用户Detail表
- (BOOL)createTableUserDetail;

//插入或者更新用户Detail数据
- (BOOL)insertOrUpdateUserDetail:(id<AKUserDetailProtocol>)user;

//更新用户detail信息
-(BOOL)updateUserDetailByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

/**
 *  查询多个用户详细信息
 */
- (NSArray *)queryUserDetailsByID:(NSArray *)uids;

//查询单条User详细信息
-(id<AKUserDetailProtocol>)queryUserDetailByID:(NSString*)uid;

/**
 *  删除单条用户详情
 */
- (BOOL)deleteUserDetailByID:(NSString *)uid;


@end
