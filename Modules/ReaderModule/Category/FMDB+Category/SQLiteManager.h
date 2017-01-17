//
//  SQLiteManager.h
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "VersionConst.h"
#import "InitialData.h"

#define DATABASE_PATH @"/Library/Caches/database.sqlite3"


@interface SQLiteManager : NSObject

/**
 *  数据库位置
 */
@property(nonatomic,copy)NSString * databasePath;
/**
 *  单例获取一个数据库
 */
+ (SQLiteManager *)shareSQLiteManager;
+ (SQLiteManager *)shareSQLiteManagerWithDatabasePath:(NSString *)databasePath;
/**
 *  创建一张表，如果不存在的情况下
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)createTableWithSQL:(NSString *)sql;
/**
 *  插入一条数据
 *
 *  @param sql  sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  若存在则替换，不存在则插入
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertOrReplaceWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  修改数据
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)updateWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  删除数据
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)deleteWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  查询,记得使用完成之后[rs close]下
 *
 *  @param sql sql语句
 *
 *  @return 数组
 */
- (FMResultSet *)queryWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array;
/**
 *  检查数据库版本，不相符则更新
 */
+ (void)checkAndUpdateDatabaseVersion;

+ (BOOL)insertToTableName:(NSString *)tableName andObject:(id)object;

+ (BOOL)insertWithNoArrayToTableName:(NSString *)tableName andObject:(id)object;

+ (BOOL)insertOrReplaceWithNoArrayToTableName:(NSString *)tableName andObject:(id)object;

+ (BOOL)insertOrReplaceToTableName:(NSString *)tableName andObject:(id)object;

/**
 *  插入一组数据，事务添加
 */
+ (BOOL)insertToTableWithDataArray:(NSArray *)dataArray andSQL:(NSString *)sql;

+ (NSArray *)queryAllWithTableName:(NSString *)tableName andClass:(Class)clazz;

+ (NSArray *)queryByParamsWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params;

+ (BOOL)deleteWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params;

+ (BOOL)updateWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params andWhereParams:(NSDictionary *)whereParams;

+ (NSArray *)propertyArrayWithClass:(Class)clazz;

@end
