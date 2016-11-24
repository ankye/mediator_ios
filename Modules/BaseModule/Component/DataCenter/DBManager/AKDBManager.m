//
//  AKDBManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"

@interface AKDBManager()

@property (nonatomic,strong) NSMutableDictionary* dbQueues;

@end

@implementation AKDBManager


SHARED_METHOD_IMPLEMENTATION


/**
 判断是否存在DB

 @param dbname DB名称
 @return YES OR NO
 */
-(BOOL)isExistDB:(NSString*)dbname
{
    NSString* dbPath = [FileHelper getFMDBPath:dbname];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]){
        return NO;
    }
    return YES;
}


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
        if (i == 0) { //数组第一个默认为主键
            [createSql appendString:@"PRIMARY KEY NOT NULL"];
        }
        if (i < [arrColumns count]-1) {
            [createSql appendString:@","];
        }else
        {
            [createSql appendString:@")"];
        }
        
    }
    
    [self execute:queue withSql:createSql];
    
}





@end



