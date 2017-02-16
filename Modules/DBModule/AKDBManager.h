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
#define AKDB_INSERT_OR_REPLACE_INTR(_prefix, _model ) \
- (BOOL)_prefix##_insertOrReplace:( _model *)model;

#define AKDB_INSERT_OR_REPLACE_IMPL( _prefix,_model , _dbname , _tablename , _sqlformat) \
- (BOOL)_prefix##_insertOrReplace:( _model *)model \
{ \
    return [self insertOrReplaceWithDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat andObject:model]; \
}



@interface AKDBManager : NSObject

SINGLETON_INTR(AKDBManager)


/**
 判断是否存在表
 
 @param dbname 库名
 @param tableName 表名
 @return YES/NO
 */
- (BOOL)isExistTableWithDBName:(NSString*)dbname withTableName:(NSString *)tableName;


#pragma mark create

/**
 创建表
 
 @param dbname 库名
 @param tableName 表名
 @param sql 创建表sql语句
 @return YES/NO
 */
-(BOOL)createTableWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSql:(NSString*)sql;

#pragma mark insert or replace

/**
 插入一个object实例入库，自动转换为数据集
 
 @param dbname 库名
 @param tableName 表名
 @param object 实体object
 @return YES/NO
 */
- (BOOL)insertWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andObject:(NSObject<AKDataObjectProtocol>*)object;

/**
 插入或者替换单条记录集，指定sql语句
 
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql语句
 @param object 实体object
 @return YES/NO
 */
- (BOOL)insertOrReplaceWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat andObject:(NSObject<AKDataObjectProtocol>*)object;


/**
 插入或者替换单条记录集，自动获取sql语句
 
 @param dbname 库名
 @param tableName 表名
 @param object 实例object
 @return YES/NO
 */
- (BOOL)insertOrReplaceWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andObject:(NSObject<AKDataObjectProtocol>*)object;


/**
 批量插入数据,失败回滚
 
 @param dbname 库名
 @param sqlFormat 表名
 @param dataArray 数据集数组
 @return YES/NO
 */
- (BOOL)insertDataArrayWithDBName:(NSString*)dbname withSqlFormat:(NSString *)sqlFormat withDataArray:(NSArray *)dataArray;


#pragma mark query

/**
 查询单个表所有数据集
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例数组
 */
- (NSArray *)queryAllRowsWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass;


/**
 查询单个表数据集,带查询参数，查询参数为空和queryAllRows效果一样
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例数组
 */
-(NSArray*)queryRowsByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params withModel:(Class)aClass;


/**
 查询单条数据,带查询参数
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例
 */
-(AKBaseModel*)queryRowByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params withModel:(Class)aClass;


#pragma mark update



/**
 更新数据集
 
 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @param attributes 更新属性
 @return YES/NO
 */
-(BOOL)updateByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params  withAttributes:(NSDictionary*)attributes;


/**
 更新数据集，类名和表名可选填一个
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 类名
 @param whereParams 查询参数
 @param params 更新参数
 @return YES/NO
 */
-(BOOL)updateWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass andWhereParams:(NSDictionary *)whereParams andParams:(NSDictionary *)params;


#pragma mark delete

/**
 删除数据集
 
 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @return YES/NO
 */
-(BOOL) deleteByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params;

/**
 删除数据集
 
 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @return YES/NO
 */
-(BOOL) deleteByParamsWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass andWhereParams:(NSDictionary *)params;


 
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
