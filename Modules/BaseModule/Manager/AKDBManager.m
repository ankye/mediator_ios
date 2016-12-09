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
@property (nonatomic,strong) NSArray* filterAttrs;

@end

@implementation AKDBManager

SINGLETON_IMPL(AKDBManager)

-(id)init
{
    self = [super init];
    if(self){
        self.filterAttrs = @[@"superclass", @"description", @"debugDescription", @"hash"];
        
    }
    return self;
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
        NSLog(@"DB Path %@",[FileHelper getFMDBPath:dbname]);
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






/**
 取得执行结果，返回值为int类型，保证一条数据的情况下使用该方法

 @param queue FMDatabaseQueue
 @param sql String sql
 @return int value
 */
- (int)executeForInt:(FMDatabaseQueue*)queue withSql:(NSString *)sql
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
 判断一张表是否已经存在

 @param queue 队列
 @param mClass Model Class
 @return 返回YES OR NO
 */
- (BOOL)isExistTable:(FMDatabaseQueue*)queue withModelClass:(Class)mClass
{

     __block BOOL ret = 0;
     [queue inDatabase:^(FMDatabase *db)   {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", NSStringFromClass(mClass)];
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
                if ([self.filterAttrs containsObject:keys[i]] == YES){
                    continue;
                }
                if ([attrs[i] startWithSubString:kPropertyAttrString]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' VARCHAR", sql, keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrShort]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' INTEGER", sql, keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrFloat]) {
                    sql = [NSString stringWithFormat:@"%@,'%@' FLOAT", sql, keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrSignal]){
                    //忽略
                }else{
                    sql = [NSString stringWithFormat:@"%@,'%@' VARCHAR", sql, keys[i]];
                }
                
                
            }
        }
        @catch (NSException *exception) {
            DDLogError(@"exception = %@",exception);
        }
        @finally {
            
        }
        
        sql = [NSString stringWithFormat:@"%@)",sql];
        DDLogInfo(@"sql %@",sql);
        [db executeStatements:sql];
    }];
}


/**
 插入Models记录，一条和多条

 @param queue FMDatabaseQueue队列
 @param modelArray 数据Model集
 */
- (BOOL)insertModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray {
    __block BOOL result = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            DDLogError(@"数据库打开失败");
            return;
        }
        
        if (modelArray.count == 0) {
            return;
        }
        NSMutableArray* filterIDs = [[NSMutableArray alloc] init];
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@", NSStringFromClass([[modelArray objectAtIndex:0] class])];
        NSArray *keys = [[modelArray objectAtIndex:0] fetchDBObjectPropertyList];
         NSArray *attrs = [[modelArray objectAtIndex:0] fetchDBObjectPropertyAttributes];
        
        [sql appendFormat:@" ("];
        for (int i =0; i< keys.count; i++) {
            if ([keys[i] isEqualToString:@"pk_cid"]) {
                continue;
            }
            if ([self.filterAttrs containsObject:keys[i]] == YES){
                [filterIDs addObject:@(i)];
                continue;
            }
            [sql appendFormat:@" '%@',",keys[i]];
        }
        if ([[sql substringWithRange:NSMakeRange(sql.length - 1, 1)] isEqualToString:@","]) {
            sql = [[sql substringToIndex:sql.length - 1] mutableCopy];
        }
        [sql appendFormat:@" )"];
        
        [sql appendFormat:@" VALUES ("];
        for (int i = 0; i < keys.count; i++) {
            if ([keys[i] isEqualToString:@"pk_cid"]) {
                continue;
            }
            if( [filterIDs containsObject:@(i)] == YES){
                continue;
            }
            if([attrs[i] startWithSubString:kPropertyAttrSignal]){
                continue;
            }
            [sql appendFormat:@" ?,"];
        }
        if ([[sql substringWithRange:NSMakeRange(sql.length - 1, 1)] isEqualToString:@","]) {
            sql = [[sql substringToIndex:sql.length - 1] mutableCopy];
        }
        [sql appendFormat:@" )"];
        DDLogInfo(@"--sql: -->%@",sql);
        
        for (int k = 0; k < modelArray.count; k++) {
            id model = [modelArray objectAtIndex:k];
            NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i = 0; i < keys.count; i++) {
                if ([keys[i] isEqualToString:@"pk_cid"]) {
                    continue;
                }
                if ([self.filterAttrs containsObject:keys[i]] == YES){
                    continue;
                }
                if([attrs[i] startWithSubString:kPropertyAttrSignal]){
                    continue;
                }
                id obj = [model valueForKey:keys[i]];
                if(obj == nil){
                    obj = @"";
                }
                [arguments addObject:obj];
            }
            [db executeUpdate:sql withArgumentsInArray:arguments];
        }
        
        
    }];
    
    return result;
    
}



/**
 更新数据Models

 @param queue FMDatabaseQueue
 @param modelArray 数据集Model

 */
- (BOOL)updateModels:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray
{
    __block BOOL result = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            DDLogError(@"数据库打开失败");
            return;
        }
        
        if (modelArray.count == 0) {
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@", NSStringFromClass([[modelArray objectAtIndex:0] class])];
        
        
        NSArray *keys = [[modelArray objectAtIndex:0] fetchDBObjectPropertyList];
        NSArray *attrs = [[modelArray objectAtIndex:0] fetchDBObjectPropertyAttributes];

        [sql appendFormat:@" SET"];
        for (int i =0; i< keys.count; i++) {
            if ([keys[i] isEqualToString:@"pk_cid"]) {
                continue;
            }
            if ([self.filterAttrs containsObject:keys[i]] == YES){
               
                continue;
            }
            if([attrs[i] startWithSubString:kPropertyAttrSignal]){
                continue;
            }
            [sql appendFormat:@" %@ = ?,",keys[i]];
        }
        if ([[sql substringWithRange:NSMakeRange(sql.length - 1, 1)] isEqualToString:@","]) {
            sql = [[sql substringToIndex:sql.length - 1] mutableCopy];
        }
        [sql appendFormat:@" WHERE pk_cid = ?"];
        DDLogInfo(@"--sql: -->%@",sql);
        
        for (int k = 0; k < modelArray.count; k++) {
            id model = [modelArray objectAtIndex:k];
            NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i = 0; i < keys.count; i++) {
                if ([keys[i] isEqualToString:@"pk_cid"]) {
                    continue;
                }
                if ([self.filterAttrs containsObject:keys[i]] == YES){
                    continue;
                }
                if([attrs[i] startWithSubString:kPropertyAttrSignal]){
                    continue;
                }
                id obj = [model valueForKey:keys[i]];
                if(obj != nil){
                    [arguments addObject:obj];
                }
            }
            [arguments addObject:[model valueForKey:@"pk_cid"]];
            [db executeUpdate:sql withArgumentsInArray:arguments];
        }
        
        
    }];
    
    return result;
    
}


/**
 删除单个Model

 @param queue FMDatabaseQueue
 @param model Model数据
 */
- (BOOL)deleteModel:(FMDatabaseQueue*)queue withModel:(id)model{
    __block BOOL result = YES;
    [queue inDatabase:^(FMDatabase *db) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            DDLogError(@"数据库打开失败");
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE pk_cid = ?", NSStringFromClass([model class])];
        result = [db executeUpdate:sql withArgumentsInArray:@[[model valueForKey:@"pk_cid"]]];
    }];
    
    
    return result;
}


/**
 删除多个model

 @param queue FMDatabaseQueue
 @param modelArray model数组
 */
- (BOOL)deleteModelArray:(FMDatabaseQueue*)queue withModelArray:(NSMutableArray *)modelArray {
    __block BOOL result = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            DDLogError(@"数据库打开失败");
            return;
        }
        
        if (modelArray.count == 0) {
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE pk_cid = ?", NSStringFromClass([[modelArray objectAtIndex:0] class])];
        for (int i = 0; i < modelArray.count; i++) {
            id model = [modelArray objectAtIndex:i];
            [db executeUpdate:sql withArgumentsInArray:@[[model valueForKey:@"pk_cid"]]];
        }
        
    }];
    
    return result;
    
}



/**
 查询数据
 
 @param queue FMDatabaseQueue
 @param sqlString sql语句
 @param mClass Model class
 @return 返回model数组
 */
- (NSMutableArray*)query:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString toModelClass:(Class)mClass{
    __block NSMutableArray *modelArray = [NSMutableArray array];
    
    [queue inDatabase:^(FMDatabase *db) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            DDLogError(@"数据库打开失败");
            return;
        }
        
        [db setShouldCacheStatements:YES];
        
        FMResultSet *resultSet = [db executeQuery:sqlString];
        id mObject = [[mClass alloc] init];
        NSArray *keys = [mObject fetchDBObjectPropertyList];
        NSArray *attrs = [mObject fetchDBObjectPropertyAttributes];
        while([resultSet next]) {
            // 使用表名作为类名创建对应的类的对象
            id model = [[mClass alloc]init];
            for (int i =0; i< keys.count; i++) {
                
                if ([self.filterAttrs containsObject:keys[i]] == YES){
                    continue;
                }
                
                // 值是从我们的数据表的Column字段取出来，
                
                //判断属性的是什么类型，那么获取的方法也不一样
               
//                NSLog(@"KEY = %@",keys[i]);
                if ([attrs[i] startWithSubString:kPropertyAttrString]) {
                     NSString* result = (NSString*)[resultSet stringForColumn:keys[i]];
                    if(result){
                        [model setValue:result forKey:keys[i]];
                    }else{
                        [model setValue:@"" forKey:keys[i]];
                    }
                }else if ([attrs[i] startWithSubString:kPropertyAttrShort] || [attrs[i] startWithSubString:kPropertyAttrLong]) {
                    
                    [model setValue:@([resultSet intForColumn:keys[i]]) forKey:keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrFloat]) {
                    [model setValue:@([resultSet doubleForColumn:keys[i]]) forKey:keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrNumber]) {
                    [model setValue:@([resultSet doubleForColumn:keys[i]]) forKey:keys[i]];
                }else if([attrs[i] startWithSubString:kPropertyAttrSignal]){
                    
                }else{
                    [model setValue:[resultSet stringForColumn:keys[i]] forKey:keys[i]];
                }
                
            }
            [modelArray addObject:model];
        }
    }];
    
    return modelArray;
}

/**
 查询所有的数据

 @param queue FMDatabaseQueue
 @param mClass Model Class
 @return Model数组
 */
- (NSMutableArray*)queryAllToModel:(FMDatabaseQueue*)queue toModelClass:(Class)mClass
{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass(mClass)];
    return [self query:queue withSql:sqlString toModelClass:mClass];
}

/**
 查询单个数据
 
 @param queue FMDatabaseQueue
 @param mClass Model Class
 @return Model 或者 nil
 */
- (id)queryToModel:(FMDatabaseQueue*)queue withSql:(NSString*)sqlString toModelClass:(Class)mClass
{
    
    NSMutableArray* arr = [self query:queue withSql:sqlString toModelClass:mClass];
    if(arr && [arr count]>0){
        return [arr objectAtIndex:0];
    }
    return nil;
}


- (BOOL)createTable:(FMDatabaseQueue*)queue withTableName:(NSString *)tableName withSQL:(NSString *)sqlString
{
    __block BOOL ok = YES;
    [queue inDatabase:^(FMDatabase *db) {
        if(![db tableExists:tableName]){
            ok = [db executeUpdate:sqlString withArgumentsInArray:nil];
        }
    }];
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



