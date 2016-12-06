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
 取得执行结果，返回值为int类型，保证一条数据的情况下使用该方法
 
 @param queue FMDatabaseQueue
 @param sql String sql
 @return int value
 */
- (int)executeForInt:(FMDatabaseQueue*)queue withSql:(NSString *)sql;


/**
 判断一张表是否已经存在
 
 @param queue 队列
 @param mClass Model Class
 @return 返回YES OR NO
 */
- (BOOL)isExistTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass;


/**
 通过Model创建表
 
 @param queue FMDatabaseQueue
 @param mClass 模型类
 */
- (void)createTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass;




/**
 插入Models记录，一条和多条
 
 @param queue FMDatabaseQueue队列
 @param modelArray 数据Model集
 */
- (BOOL)insertModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray;


/**
 更新数据Models
 
 @param queue FMDatabaseQueue
 @param modelArray 数据集Model
 
 */
- (BOOL)updateModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray;


/**
 删除单个Model
 
 @param queue FMDatabaseQueue
 @param model Model数据
 */
- (BOOL)deleteModel:(FMDatabaseQueue*)queue withModel:(id)model;


/**
 删除多个model
 
 @param queue FMDatabaseQueue
 @param modelArray model数组
 */
- (BOOL)deleteModelArray:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray ;



/**
 查询数据
 
 @param queue FMDatabaseQueue
 @param sqlString sql语句
 @param mClass Model class
 @return 返回model数组
 */
- (NSMutableArray*)query:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString toModelClass:(Class)mClass;


/**
 查询所有的数据 转化为model
 
 @param queue FMDatabaseQueue
 @param mClass Model Class
 @return Model数组
 */
- (NSMutableArray*)queryAllToModel:(FMDatabaseQueue*)queue toModelClass:(Class)mClass;
/**
 查询单个数据 转化为model
 
 @param queue FMDatabaseQueue
 @param mClass Model Class
 @return Model 或者 nil
 */
- (id)queryToModel:(FMDatabaseQueue*)queue withSql:(NSString*)sqlString toModelClass:(Class)mClass;



/**
 *  表创建
 */
- (BOOL)createTable:(FMDatabaseQueue*)queue withTableName:(NSString*)tableName withSQL:(NSString*)sqlString;

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
