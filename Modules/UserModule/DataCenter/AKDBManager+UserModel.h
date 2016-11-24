//
//  AKDBManager+UserModel.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKDBManager (UserModel)


/**
 创建用户表

 @return YES OR NO
 */
-(BOOL) createUserTable;


/**
 查询用户返回字典数据

 @param uid 用户id string格式
 @return YES OR NO
 */
-(NSDictionary*) queryUserByUid:(NSString*)uid;


/**
 插入用户数据

 @param user UserModel
 @return YES OR NO
 */
-(BOOL) insertUser:(UserModel*)user;


/**
 更新用户信息

 @param user UserModel
 @return YES OR NO
 */
-(BOOL) updateUser:(UserModel*)user;


/**
 通过用户id删除一条用户信息数据

 @param uid 用户ID
 @return YES OR NO
 */
-(BOOL) deleteUserByID:(NSString*)uid;


@end
