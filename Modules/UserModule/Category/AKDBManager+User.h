//
//  AKDBManager+User.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#define KAK_TLUSER_DBNAME @"TLUser"

@interface AKDBManager (User)


/**
 创建用户表

 @return YES or NO
 */
- (BOOL)createTableUser;

- (BOOL)insertOrUpdateUser:(id<AKUserProtocol>)user;

-(BOOL)updateUserByID:(NSString*)uid withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

/**
 *  查询多个UserProtocol用户信息
 */
- (NSArray *)queryUsersByID:(NSArray *)uids;

//查询单条UserProtocol信息
-(id<AKUserProtocol>)queryUserByID:(NSString*)uid;

/**
 *  删除单条会话
 */
- (BOOL)deleteUserByID:(NSString *)uid;
@end
