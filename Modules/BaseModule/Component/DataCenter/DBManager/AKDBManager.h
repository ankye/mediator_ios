//
//  AKDBManager.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"
#import <FMDB/FMDB.h>

@interface AKDBManager : NSObject

SINGLETON_INTR(AKDBManager)



/**
 获取DB操作队列，一个DB一个操作队列
 
 @param dbname db名称
 @return 返回队列
 */
-(FMDatabaseQueue*)getQueue:(NSString*)dbname;



/**
 清理单个队列
 
 @param dbname 数据库名
 */
-(void)closeQueue:(NSString*)dbname;

/**
 清理所有队列
 */
-(void)closeQueues;


/**
 操作一条SQL，并加事务处理
 
 @param queue FMDatabaseQueue
 @param sql String sql
 @return YES OR NO
 */
- (BOOL)execute:(FMDatabaseQueue*)queue withSql:(NSString *)sql;


/**
 取得查询结果，返回值为数据字典，key为字段名 数据结构：<row <columnName value>>
 
 @param queue FMDatabaseQueue
 @param sql String sql
 @return 数据字典集合
 */
- (NSMutableDictionary *)getResultsByColName:(FMDatabaseQueue*)queue withSql:(NSString *)sql;


/**
 取得查询结果，返回值为数据字典，key为字段名 数据结构：<row <columnName value>>
 
 @param queue FMDatabaseQueue
 @param sql String sql
 @return 数据数组集合
 */
- (NSMutableArray *)executeQuery:(FMDatabaseQueue*)queue withSql:(NSString *)sql;

/**
 取得查询结果，返回值为int类型，保证一条数据的情况下使用该方法
 
 @param queue FMDatabaseQueue
 @param sql String sql
 @return int value
 */
- (int)getResultToInt:(FMDatabaseQueue*)queue withSql:(NSString *)sql;


/**
 判断一张表是否已经存在
 
 @param queue 队列
 @param tname 表名
 @return 返回YES OR NO
 */
- (BOOL)isExistTable:(FMDatabaseQueue*)queue withTableName:(NSString *)tname;


/**
 创建表
 
 @param queue FMDatabaseQueue
 @param tname 表名
 @param arrColumns 属性列表
 */
-(void)createTable:(FMDatabaseQueue*)queue withTableName:(NSString*)tname withColumns:(NSMutableArray*)arrColumns;


/**
 通过Model创建表
 
 @param queue FMDatabaseQueue
 @param mClass 模型类
 */
- (void)createTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass;

@end
