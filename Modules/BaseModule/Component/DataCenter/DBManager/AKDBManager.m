//
//  AKDBManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "DBBaseObject.h"
#import <objc/runtime.h>
#import "NSString+Tools.h"


@interface AKDBManager()

@property (nonatomic,strong) NSMutableDictionary* dbQueues;

@end

@implementation AKDBManager

SINGLETON_IMPL(AKDBManager)



/**
 获取DB操作队列，一个DB一个操作队列

 @param dbname db名称
 @return 返回队列
 */
-(FMDatabaseQueue*)getQueue:(NSString*)dbname
{
    if(!_dbQueues){
        _dbQueues = [[NSMutableDictionary alloc] init];
    }
    FMDatabaseQueue* queue = [_dbQueues objectForKey:dbname];
    if(queue == nil){
        queue = [FMDatabaseQueue databaseQueueWithPath: [FileHelper getFMDBPath:dbname]];
        [_dbQueues setObject:queue forKey:dbname];
    }
    
    return queue;
    
}


/**
 清理单个队列

 @param dbname 数据库名
 */
-(void)closeQueue:(NSString*)dbname
{
    if(_dbQueues){
        FMDatabaseQueue* queue = [_dbQueues objectForKey:dbname];
        [queue close];
        queue=nil;
        _dbQueues[dbname] = nil;
    }
    
}


/**
 清理所有队列
 */
-(void)closeQueues
{
    if(_dbQueues){
        for (NSString *key in [_dbQueues allKeys]) {
            [self closeQueue:key];
        }
    }
}

-(void)dealloc
{
    [self closeQueues];
    _dbQueues = nil;
}



#pragma mark -
#pragma mark 数据库插入更新操作

/**
 操作一条SQL，并加事务处理

 @param queue FMDatabaseQueue
 @param sql String sql
 @return YES OR NO
 */
- (BOOL)execute:(FMDatabaseQueue*)queue withSql:(NSString *)sql
{
    __block BOOL ret;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback)
     {
         //DDLogInfo(@"%@", sql);
         ret = [db executeUpdate:sql];
         if (!ret) {
             //操作失败，回滚所有操作
             *rollback = YES;
         }else
         {
             //如果操作成功，返回消息给主画面，通知画面更新数据
//             if (_isPostNotification) {
//                 NSMutableArray *arrSql = [NSMutableArray arrayWithObjects:sql, nil];
//                 [self performSelectorOnMainThread:@selector(postNotification:) withObject:arrSql waitUntilDone:NO];
//             }
         }
     }];
    
    return ret;
}

#pragma mark -
#pragma mark 数据库查询操作

/**
 取得查询结果，返回值为数据字典，key为字段名 数据结构：<row <columnName value>>

 @param queue FMDatabaseQueue
 @param sql String sql
 @return 数据字典集合
 */
- (NSMutableDictionary *)getResultsByColName:(FMDatabaseQueue*)queue withSql:(NSString *)sql
{
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    [queue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        
        int row = 0;
        while ([retArrData next])
        {
            NSMutableDictionary *dictrow = [NSMutableDictionary dictionaryWithCapacity:1];
            int columnCount = [retArrData columnCount];
            
            int columnIdx = 0;
            
            for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
                
                NSString *columnName = [retArrData columnNameForIndex:columnIdx];
                id objectValue = [retArrData objectForColumnIndex:columnIdx];
                [dictrow setObject:objectValue forKey:columnName];
            }
            [dict setObject:dictrow forKey:[NSNumber numberWithInt:row]];
            row = row +1;
        }
        
    }];
    
    return dict;
}



/**
 取得查询结果，返回值为数据字典，key为字段名 数据结构：<row <columnName value>>

 @param queue FMDatabaseQueue
 @param sql String sql
 @return 数据数组集合
 */
- (NSMutableArray *)executeQuery:(FMDatabaseQueue*)queue withSql:(NSString *)sql
{
    __block NSMutableArray *result = [NSMutableArray array];
    
    [queue inDatabase:^(FMDatabase *db)   {
        FMResultSet *fmResultSet = [db executeQuery:sql];
        
        while ([fmResultSet next]){
            [result addObject:[fmResultSet resultDictionary]];
        }
        
    }];
    return result;
}



/**
 取得查询结果，返回值为int类型，保证一条数据的情况下使用该方法

 @param queue FMDatabaseQueue
 @param sql String sql
 @return int value
 */
- (int)getResultToInt:(FMDatabaseQueue*)queue withSql:(NSString *)sql
{
    __block int ret = 0;
    [queue inDatabase:^(FMDatabase *db)   {
        FMResultSet *retArrData = [db executeQuery:sql];
        while ([retArrData next])
        {
            ret = ([retArrData objectForColumnIndex:0]== [NSNull null])?0:[retArrData intForColumnIndex:0];
        }
        
    }];
    return ret;
}


/**
 创建表

 @param queue FMDatabaseQueue
 @param tname 表名
 @param arrColumns 属性列表
 */
-(void)createTable:(FMDatabaseQueue*)queue withTableName:(NSString*)tname withColumns:(NSMutableArray*)arrColumns
{
    
    //创建变量
    NSMutableString *createSql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS "];
    
    [createSql appendString:tname];
    
    [createSql appendString:@" ( "];
    
    for (int i=0;i<[arrColumns count]; i++) {
        
        NSMutableArray *arrColumn =[arrColumns objectAtIndex:i];
        [createSql appendString:[arrColumn objectAtIndex:0]];
        [createSql appendString:@" "];
        [createSql appendString:[arrColumn objectAtIndex:1]];
        if ([[arrColumn objectAtIndex:2] length]>0) {
            [createSql appendString:@"("];
            [createSql appendString:[arrColumn objectAtIndex:2]];
            [createSql appendString:@")"];
        }
        [createSql appendString:@" "];
        if ([[arrColumn objectAtIndex:3] boolValue]) {
            [createSql appendString:@"PRIMARY KEY NOT NULL"];
        }
        if (i < [arrColumns count]-1) {
            [createSql appendString:@","];
        }else
        {
            [createSql appendString:@")"];
        }
        
    }
    
    NSLog(@"sql = %@",createSql);
    
    [self execute:queue withSql:createSql];
    
}



/**
 判断一张表是否已经存在

 @param queue 队列
 @param tname 表名
 @return 返回YES OR NO
 */
- (BOOL)isExistTable:(FMDatabaseQueue*)queue withTableName:(NSString *)tname
{

     __block BOOL ret = 0;
     [queue inDatabase:^(FMDatabase *db)   {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tname];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
                ret = NO;
            }
            else{
                ret = YES;
            }

        }
        
    }];
    return ret;
}



/**
 通过Model创建表

 @param queue FMDatabaseQueue
 @param mClass 模型类
 */
- (void)createTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass
{
    NSAssert([mClass isSubclassOfClass:[DBBaseObject class]], @"录入数据库的模型，必须要继承DBBaseObject！");
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (pk_cid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL", NSStringFromClass(mClass)];
        
        @try {
            NSArray *keys, *attrs;
            id mObject = [[mClass alloc]init];
            keys = [mObject fetchDBObjectPropertyList];
            attrs = [mObject fetchDBObjectPropertyAttributes];
            for (int i = 0 ; i < keys.count ; i++) {
                if ([keys[i] isEqualToString:@"pk_cid"]) {
                    continue;
                }
             
                if ([attrs[i] startWithSubString:kPropertyAttrString]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' VARCHAR", sql, keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrShort]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' INTEGER", sql, keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrFloat]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' FLOAT", sql, keys[i]];
                }else{
                    sql = [NSString stringWithFormat:@"%@,'%@' VARCHAR", sql, keys[i]];
                }
                
                
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@",exception);
        }
        @finally {
            
        }
        
        sql = [NSString stringWithFormat:@"%@)",sql];
        NSLog(@"sql %@",sql);
        [db executeStatements:sql];
    }];
}


@end



