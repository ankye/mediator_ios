//
//  AKDBManager+UserModel.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserModel.h"

#define KAK_USER_DBNAME @"User"
#define KAK_USER_TNAME @"User"

@implementation AKDBManager (UserModel)


/**
 判断是否存在用户表

 @return YES OR NO
 */
-(BOOL)isExistUserTable
{
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    
    if([self isExistTable:queue withTableName:KAK_USER_TNAME]){
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
//    NSMutableArray* columns = [[NSMutableArray alloc] initWithObjects:
//        [NSArray arrayWithObjects:@"uid",@"NVARCHAR",@"32",@(YES),nil],
//        [NSArray arrayWithObjects:@"usernum",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"head",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"nickname",@"NVARCHAR",@"128",@(NO),nil],
//        [NSArray arrayWithObjects:@"sign",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"phone",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"email",@"NVARCHAR",@"64",@(NO),nil],
//        [NSArray arrayWithObjects:@"token",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"money",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"third",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"viplevel",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"lastmodnickname",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"sex",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"fans",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"follow",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"address",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"rz",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"security",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"is_manager",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"head_640",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"birthday",@"NVARCHAR",@"64",@(NO),nil],
//        [NSArray arrayWithObjects:@"hometown",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"version",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"user_tag",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"anchor",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"show_author_type_tag",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"gameb",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"after_noble_exp",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"before_noble_exp",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"noble_exp",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"upgrade_progress",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"medal_id",@"NVARCHAR",@"256",@(NO),nil],
//        [NSArray arrayWithObjects:@"last_login_time",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"latitude",@"NVARCHAR",@"32",@(NO),nil],
//        [NSArray arrayWithObjects:@"longitude",@"NVARCHAR",@"32",@(NO),nil],
//        nil];
//   
//    

    
    FMDatabaseQueue* queue = [self getQueue:KAK_USER_DBNAME];
    
    [self createTable:queue withModelClass:[UserModel class]];
   // [self createTable:queue withTableName:KAK_USER_TNAME withColumns:columns];
    
    
  
    return YES;
}


/**
 查询用户返回字典数据
 
 @param uid 用户id string格式
 @return YES OR NO
 */
-(NSDictionary*) queryUserByUid:(NSString*)uid
{
    return nil;
}


/**
 插入用户数据
 
 @param user UserModel
 @return YES OR NO
 */
-(BOOL) insertUser:(UserModel*)user
{
    return NO;
}


/**
 更新用户信息
 
 @param user UserModel
 @return YES OR NO
 */
-(BOOL) updateUser:(UserModel*)user
{
    return NO;
}


/**
 通过用户id删除一条用户信息数据
 
 @param uid 用户ID
 @return YES OR NO
 */
-(BOOL) deleteUserByID:(NSString*)uid
{
    return NO;
}



@end
