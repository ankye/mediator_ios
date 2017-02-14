//
//  AKDBManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"

#import <objc/runtime.h>


@interface AKDBManager()

@property (nonatomic,strong) NSMutableDictionary* dbQueues;

@end

@implementation AKDBManager

SINGLETON_IMPL(AKDBManager)


#pragma mark private method
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
        NSLog(@"DB Path %@",[FileHelper getFMDBPath:dbname]);
        [_dbQueues setObject:queue forKey:dbname];
    }
    
    return queue;
    
}


/**
 关闭单个队列

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
 关闭所有队列
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


- (BOOL)createTableWithQueue:(FMDatabaseQueue*)queue withTableName:(NSString *)tableName withSQL:(NSString *)sqlString
{
    __block BOOL ok = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if(![db tableExists:tableName]){
            ok = [db executeUpdate:sqlString withArgumentsInArray:nil];
        }
    }];
    return ok;
}




#pragma mark public method


- (BOOL)isExistTable:(FMDatabaseQueue*)queue withTableName:(NSString *)tableName
{
    __block BOOL ok = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if([db tableExists:tableName]){
            ok = YES;
        }else{
            ok = NO;
        }
    }];
    return ok;
}

-(BOOL)createTableWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSql:(NSString*)sql
{
    NSString *sqlString = [NSString stringWithFormat:sql, tableName];
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    return [self createTableWithQueue:queue withTableName:tableName withSQL:sqlString];

}




-(NSArray*)queryRowsByParams:(NSDictionary*)params withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName
{
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
    NSArray* keys = params.allKeys;
    for(NSInteger i=0; i< keys.count; i++){
        NSString* key = [keys objectAtIndex:i];
        sql = [sql stringByAppendingFormat:@"%@ = '%@'",key, [params objectForKey:key]];
        if(i < keys.count -1){
            sql = [sql stringByAppendingString:@" and "];
        }
    }
     __block NSMutableArray *data = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    [self excuteQuery:queue withSql:sql resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            AKBaseModel* model = aClass.new;
            [model resultSetToModel:retSet];
            [data addObject:model];
        }
        [retSet close];
    }];
    return data;
}

-(AKBaseModel*)queryRowByParams:(NSDictionary*)params withModel:(Class)aClass withDBName:(NSString*)dbname withTableName:(NSString*)tableName
{
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
    NSArray* keys = params.allKeys;
    for(NSInteger i=0; i< keys.count; i++){
        NSString* key = [keys objectAtIndex:i];
        sql = [sql stringByAppendingFormat:@" %@ = %@",key, [params objectForKey:key]];
        if(i < keys.count -1){
            sql =[sql stringByAppendingString:@" and "];
        }
    }
    
    FMDatabaseQueue* queue = [self getQueue:KAK_TLUSER_DBNAME];
    __block  AKBaseModel* model = nil;
    
    [self excuteQuery:queue withSql:sql resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            model = aClass.new;
            [model resultSetToModel:retSet];
            
        }
        [retSet close];
    }];
    return model;
}

-(BOOL)updateByParams:(NSDictionary*)params withDBName:(NSString*)dbname withTableName:(NSString*)tableName withAttributes:(NSDictionary*)attributes
{
    NSString* sql = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
    
    NSArray* attrKeys = attributes.allKeys;
    for(NSInteger i=0; i< attrKeys.count; i++){
        NSString* key = [attrKeys objectAtIndex:i];
        sql = [sql stringByAppendingFormat:@"%@ = '%@'",key, [attributes objectForKey:key]];
        if(i < attrKeys.count -1){
            sql = [sql stringByAppendingString:@" , "];
        }else{
            sql = [sql stringByAppendingString:@" WHERE "];
        }
    }
    
    NSArray* keys = params.allKeys;
    for(NSInteger i=0; i< keys.count; i++){
        NSString* key = [keys objectAtIndex:i];
        sql = [sql stringByAppendingFormat:@"%@ = '%@'",key, [params objectForKey:key]];
        if(i < keys.count -1){
            sql = [sql stringByAppendingString:@" and "];
        }
    }
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    BOOL ok = [self excuteSQL:queue withSql:sql, nil];
    return ok;
    
}



-(BOOL) deleteByParams:(NSDictionary*)params withDBName:(NSString*)dbname withTableName:(NSString*)tableName
{
    NSString* sql = [NSString stringWithFormat:@"delete from %@ where ",tableName];
    NSArray* keys = params.allKeys;
    for(NSInteger i=0; i< keys.count; i++){
        NSString* key = [keys objectAtIndex:i];
        sql = [sql stringByAppendingFormat:@"%@ = '%@'",key, [params objectForKey:key]];
        if(i < keys.count -1){
            sql = [sql stringByAppendingString:@" and "];
        }
    }
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    BOOL ok = [self excuteSQL:queue withSql:sql, nil];
    return ok;
}

- (BOOL)insertOrUpdate:(id<AKDataObjectProtocol>)model withDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat
{
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, tableName];
    
    NSArray *arrPara = [model modelToDBRecord];
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
    
}



- (BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString withArrParameter:(NSArray *)arrParameter
{
    __block BOOL ok = NO;
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withArgumentsInArray:arrParameter];
        }];
    }
    return ok;
}

- (BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString withDicParameter:(NSDictionary *)dicParameter
{
    __block BOOL ok = NO;
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withParameterDictionary:dicParameter];
        }];
    }
    return ok;
}

- (BOOL)excuteSQL:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString,...
{
    __block BOOL ok = NO;
    if (queue) {
        va_list args;
        va_list *p_args;
        p_args = &args;
        va_start(args, sqlString);
        [queue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withVAList:*p_args];
        }];
        va_end(args);
    }
    return ok;
}

- (void)excuteQuery:(FMDatabaseQueue*)queue withSql:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock
{
    if (queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet * retSet = [db executeQuery:sqlStr];
            if (resultBlock) {
                resultBlock(retSet);
            }
        }];
    }
}




@end



