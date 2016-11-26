//
//  AKDBManager+UserModel.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserModel.h"

#define KAK_USER_DBNAME @"User"


@implementation AKDBManager (UserModel)


/**
 判断是否存在用户表

 @return YES OR NO
 */
-(BOOL)isExistUserTable
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    
    if([self isExistTable:queue withModelClass:[UserModel class]]){
        return YES;
    }
    return NO;
}

/**
 创建用户表
 
 @return YES OR NO
 */
-(BOOL) createUserTable
{
    
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    
    [self createTable:queue withModelClass:[UserModel class]];
    
  
    return YES;
}


/**
 查询用户返回字典数据
 
 @param uid 用户id
 @return YES OR NO
 */
-(UserModel*) queryUserByUid:(NSInteger)uid
{
   
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    NSString* sql = [NSString stringWithFormat:@"select * from UserModel where uid=%ld",(long)uid ];
  
    UserModel* user = [self queryToModel:queue withSql:sql toModelClass:[UserModel class]];
    
    return user;
}

/**
 判断是否存在某个用户名

 @param uid 用户ID
 @return YES OR NO
 */
-(BOOL)isExistUser:(NSInteger)uid
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    NSString* sql = [NSString stringWithFormat:@"select pk_cid from UserModel where uid=%ld",(long)uid ];
    NSInteger result = [self executeForInt:queue withSql:sql];
    if(result >0){
        return YES;
    }else{
        return NO;
    }
}

/**
 插入用户数据
 
 @param user UserModel
 @return YES OR NO
 */
-(BOOL) insertUser:(UserModel*)user
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    return [[AKDBManager sharedInstance] insertModels:queue withModelArray:[[NSMutableArray alloc] initWithObjects:user,nil]];
    
   
}


/**
 更新用户信息
 
 @param user UserModel
 @return YES OR NO
 */
-(BOOL) updateUser:(UserModel*)user
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    return [[AKDBManager sharedInstance] updateModels:queue withModelArray:[[NSMutableArray alloc] initWithObjects:user,nil]];

}


/**
 通过用户id删除一条用户信息数据
 
 @param uid 用户ID
 @return YES OR NO
 */
-(BOOL) deleteUserByID:(NSString*)uid
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    NSString* sql = [NSString stringWithFormat:@"delete from UserModel where uid=%ld",(long)uid ];
    NSInteger result = [self executeForInt:queue withSql:sql];
    if(result >0){
        return YES;
    }else{
        return NO;
    }

}



@end
