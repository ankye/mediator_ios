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


#define AK_DB_MANAGER [AKDBManager sharedInstance]

//创建表

#define AKDB_CREATE_TABLE_INTR(_prefix) \
- ( BOOL ) _prefix##_createTable;

#define AKDB_CREATE_TABLE_IMPL(_prefix , _dbname,_tablename,_sqlformat) \
- (BOOL)_prefix##_createTable \
{ \
    return [self createTableWithDBName:_dbname withTableName:_tablename withSql:_sqlformat]; \
}
//插入或者更新用户数据
#define AKDB_INSERT_OR_UPDATE_INTR(_prefix, _model ) \
- (BOOL)_prefix##_insertOrUpdate:( _model *)model;

#define AKDB_INSERT_OR_UPDATE_IMPL( _prefix,_model , _dbname , _tablename , _sqlformat) \
- (BOOL)_prefix##_insertOrUpdate:( _model *)model \
{ \
    return [self insertOrUpdate:model withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
}




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
 是否存在表

 @param queue fmdb queue
 @param tableName table name
 @return YES or NO
 */
- (BOOL)isExistTable:(FMDatabaseQueue*)queue withTableName:(NSString *)tableName;



/**
 创建表

 @param dbname 数据库
 @param tableName 数据表
 @param sql 构造sql
 @return YES OR NO
 */
-(BOOL)createTableWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSql:(NSString*)sql;
/**
 *  表创建
 */
- (BOOL)createTableWithQueue:(FMDatabaseQueue*)queue withTableName:(NSString*)tableName withSQL:(NSString*)sqlString;




-(NSArray*)queryRowsByParams:(NSDictionary*)params withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName;


-(AKBaseModel*)queryRowByParams:(NSDictionary*)params withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName;


/**
 插入或者更新整条数据

 @param model 数据Model
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql格式化语句
 @return YES OR NO
 */
- (BOOL)insertOrUpdate:(id<AKDataObjectProtocol>)model withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;



-(BOOL)updateByParams:(NSDictionary*)params withDBName:(NSString*)dbname withTableName:(NSString*)tableName withAttributes:(NSDictionary*)attributes;

 
-(BOOL) deleteByParams:(NSDictionary*)params withDBName:(NSString*)dbname withTableName:(NSString*)tableName;
 
/*
 *  执行带数组参数的sql语句 (增，删，改)
 */
-(BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString*)sqlString withArrParameter:(NSArray*)arrParameter;

/*
 *  执行带字典参数的sql语句 (增，删，改)
 */
-(BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString*)sqlString withDicParameter:(NSDictionary*)dicParameter;

/*
 *  执行格式化的sql语句 (增，删，改)
 */
- (BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString,...;

/**
 *  执行查询指令
 */
- (void)excuteQuery:(FMDatabaseQueue*)queue withSql:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock;


@end
