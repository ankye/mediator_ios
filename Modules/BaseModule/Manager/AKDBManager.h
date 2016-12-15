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

//通过主键更新单条记录
#define AKDB_UPDATE_BY_ID_INTR(_prefix) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

#define AKDB_UPDATE_BY_ID_IMPL(_prefix,_keyname,_dbname,_tablename) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values \
{ \
    return [self updateByID:_keyname withKeyValue:keyValue withDBName:_dbname withTableName:_tablename withAttributes:attributes withValues:values]; \
}

//通过2联合主键更新单条记录
#define AKDB_UPDATE_BY_ID_AND_SECOND_INTR(_prefix) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withSecondID:(NSString*)secondKeyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

#define AKDB_UPDATE_BY_ID_AND_SECOND_IMPL(_prefix,_keyname,_secondkeyname,_dbname,_tablename) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withSecondID:(NSString*)secondKeyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values \
{ \
return [self updateByID:_keyname withKeyValue:keyValue withSecondKey:_secondkeyname withSecondKeyValue:secondKeyValue  withDBName:_dbname withTableName:_tablename withAttributes:attributes withValues:values]; \
}

//通过3联合主键更新单条记录
#define AKDB_UPDATE_BY_ID_AND_SECOND_AND_THRID_INTR(_prefix) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withSecondID:(NSString*)secondKeyValue withThridID:(NSString*)thridKeyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

#define AKDB_UPDATE_BY_ID_AND_SECOND_AND_THRID_IMPL(_prefix,_keyname,_secondkeyname,_thridkeyname,_dbname,_tablename) \
-(BOOL)_prefix##_updateByID:(NSString*)keyValue withSecondID:(NSString*)secondKeyValue withThridID:(NSString*)thridKeyValue withAttributes:(NSArray*)attributes withValues:(NSArray*)values \
{ \
return [self updateByID: _keyname withKeyValue:keyValue withSecondKey:_secondkeyname withSecondValue:secondKeyValue  withThridKey:_thridkeyname withThridValue:thridKeyValue withDBName:_dbname withTableName:_tableName withAttributes:attributes withValues:values]; \
}


//查询多个信息记录
#define AKDB_QUERY_ROWS_BY_ID_INTR(_prefix) \
- (NSArray *)_prefix##_queryRowsByID:(NSArray *)keyValues;

#define AKDB_QUERY_ROWS_BY_ID_IMPL(_prefix,_model,_dbname,_tablename,_sqlformat) \
- (NSArray *) _prefix##_queryRowsByID:(NSArray *)keyValues \
{ \
    return [self queryRowsByID:keyValues withModel:[_model class] withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
}

//查询单条信息记录
#define AKDB_QUERY_ROW_BY_ID_INTR(_prefix , _model) \
-(_model*) _prefix##_queryRowByID:(NSString*)keyValue;

#define AKDB_QUERY_ROW_BY_ID_IMPL(_prefix,_model,_dbname,_tablename,_sqlformat) \
-(_model*) _prefix##_queryRowByID:(NSString*)keyValue \
{ \
    return (_model*)[self queryRowByID:keyValue withModel:[_model class] withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
}

//通过主键删除记录
#define AKDB_DELETE_BY_ID_INTR(_prefix) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue;

#define AKDB_DELETE_BY_ID_IMPL(_prefix,_dbname,_tablename,_sqlformat) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue \
{ \
    return [self deleteByID:keyValue withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
}


//通过主键删除记录,2联合主键
#define AKDB_DELETE_BY_ID_AND_SECOND_INTR(_prefix) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue withAnotherID:(NSString*)anotherKeyValue;

#define AKDB_DELETE_BY_ID_AND_SECOND_IMPL(_prefix,_dbname,_tablename,_sqlformat) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue withSecondID:(NSString*)secondKeyValue\
{ \
return [self deleteByID:keyValue withSecondKeyValue:anotherKeyValue withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
}

//通过主键删除记录,3联合主键
#define AKDB_DELETE_BY_ID_AND_SECOND_ID_AND_THRID_ID_INTR(_prefix) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue withSecondID:(NSString*)secondKeyValue withThridID:(NSString*)thridKeyValue;

#define AKDB_DELETE_BY_ID_AND_SECOND_ID_AND_THRID_ID_IMPL(_prefix,_dbname,_tablename,_sqlformat) \
- (BOOL)_prefix##_deleteByID:(NSString *)keyValue withSecondID:(NSString*)secondKeyValue withThridID:(NSString*)thridKeyValue \
{ \
return [self deleteByID:keyValue withSecondKeyValue:secondKeyValue withThridKeyValue:thridKeyValue withDBName:_dbname withTableName:_tablename withSqlFormat:_sqlformat]; \
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


//
///**
// 取得执行结果，返回值为int类型，保证一条数据的情况下使用该方法
// 
// @param queue FMDatabaseQueue
// @param sql String sql
// @return int value
// */
//- (int)executeForInt:(FMDatabaseQueue*)queue withSql:(NSString *)sql;
//
//
///**
// 判断一张表是否已经存在
// 
// @param queue 队列
// @param mClass Model Class
// @return 返回YES OR NO
// */
//- (BOOL)isExistTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass;
//
//
///**
// 通过Model创建表
// 
// @param queue FMDatabaseQueue
// @param mClass 模型类
// */
//- (void)createTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass;
//
//
//
//
///**
// 插入Models记录，一条和多条
// 
// @param queue FMDatabaseQueue队列
// @param modelArray 数据Model集
// */
//- (BOOL)insertModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray;
//
//
///**
// 更新数据Models
// 
// @param queue FMDatabaseQueue
// @param modelArray 数据集Model
// 
// */
//- (BOOL)updateModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray;
//
//
///**
// 删除单个Model
// 
// @param queue FMDatabaseQueue
// @param model Model数据
// */
//- (BOOL)deleteModel:(FMDatabaseQueue*)queue withModel:(id)model;
//
//
///**
// 删除多个model
// 
// @param queue FMDatabaseQueue
// @param modelArray model数组
// */
//- (BOOL)deleteModelArray:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray ;
//
//
//
///**
// 查询数据
// 
// @param queue FMDatabaseQueue
// @param sqlString sql语句
// @param mClass Model class
// @return 返回model数组
// */
//- (NSMutableArray*)query:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString toModelClass:(Class)mClass;
//
//
///**
// 查询所有的数据 转化为model
// 
// @param queue FMDatabaseQueue
// @param mClass Model Class
// @return Model数组
// */
//- (NSMutableArray*)queryAllToModel:(FMDatabaseQueue*)queue toModelClass:(Class)mClass;
///**
// 查询单个数据 转化为model
// 
// @param queue FMDatabaseQueue
// @param mClass Model Class
// @return Model 或者 nil
// */
//- (id)queryToModel:(FMDatabaseQueue*)queue withSql:(NSString*)sqlString toModelClass:(Class)mClass;



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


/**
 创建更新sql语句

 @param tableName 表名
 @param key 主键
 @param value 主键值
 @param attributes 需要更新的键值
 @return sql语句
 */
-(NSString*)getUpdateSqlFormatWithTableName:(NSString*)tableName withKey:(NSString*)key withKeyValue:(NSString*)value withAttributes:(NSArray*)attributes;


/**
 插入或者更新整条数据

 @param model 数据Model
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql格式化语句
 @return YES OR NO
 */
- (BOOL)insertOrUpdate:(id<AKDataObjectProtocol>)model withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;

/**
 查询多条记录

 @param keyValues 查询多个主键值
 @param aClass Model类
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql格式化语句
 @return 多条数组记录
 */
- (NSArray *)queryRowsByID:(NSArray *)keyValues withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;

/**
 查询单条记录

 @param keyValue 主键值
 @param aClass Model类
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql格式化语句
 @return 单条记录Model
 */
-(AKBaseModel*)queryRowByID:(NSString*)keyValue withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;

/**
 更新byID

 @param key key唯一标识
 @param value key数值
 @param dbname 库名
 @param attributes 键值
 @param values 数据
 @return YES OR NO
 */
-(BOOL)updateByID:(NSString*)key withKeyValue:(NSString*)value withDBName:(NSString*)dbname withTableName:(NSString*)tableName withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

-(BOOL)updateByID:(NSString*)key withKeyValue:(NSString*)value withSecondKey:(NSString*)secondKey withSecondKeyValue:(NSString*)secondKeyValue withDBName:(NSString*)dbname withTableName:(NSString*)tableName withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

-(BOOL)updateByID:(NSString*)key withKeyValue:(NSString*)value withSecondKey:(NSString*)secondKey withSecondValue:(NSString*)secondValue  withThridKey:(NSString*)thridKey withThridValue:(NSString*)thridValue withDBName:(NSString*)dbname withTableName:(NSString*)tableName withAttributes:(NSArray*)attributes withValues:(NSArray*)values;

/**
 删除byID

 @param keyValue key数值
 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql格式化语句
 @return YES OR NO
 */
- (BOOL)deleteByID:(NSString *)keyValue withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;


- (BOOL)deleteByID:(NSString *)keyValue withSecondKeyValue:(NSString*)secondKeyValue withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;


- (BOOL)deleteByID:(NSString *)keyValue withSecondKeyValue:(NSString*)secondKeyValue withThridKeyValue:(NSString*)thridKeyValue withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat;

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
