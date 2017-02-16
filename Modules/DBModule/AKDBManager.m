//
//  AKDBManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "AKDataObjectProtocol.h"
#import <objc/runtime.h>


@interface AKDBManager()

@property (nonatomic,strong) NSMutableDictionary* dbQueues;

@end

@implementation AKDBManager

SINGLETON_IMPL(AKDBManager)


#pragma mark private method start
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


/**
 根据字典参数拼接出key1=? , key2=?
 
 @param dict dict description
 @return key1=? and key2=?
 */
- (NSString *)setSqlWithDict:(NSDictionary *)dict{
    NSMutableString * str=[[NSMutableString alloc]init];
    
    BOOL b=false;
    for (NSString * key in dict.allKeys) {
        if(!b){
            b=true;
            [str appendFormat:@" %@=? ",key];
        }else{
            [str appendFormat:@" , %@=? ",key];
        }
    }
    return str;
}

/**
 根据字典参数拼接出key1=? and key2=?
 
 @param dict dict description
 @return key1=? and key2=?
 */
- (NSString *)sqlWithDict:(NSDictionary *)dict{
    NSMutableString * str=[[NSMutableString alloc]init];
    
    BOOL b=false;
    for (NSString * key in dict.allKeys) {
        if(!b){
            b=true;
            [str appendFormat:@" %@=? ",key];
        }else{
            [str appendFormat:@" and %@=? ",key];
        }
    }
    return str;
}


/**
 返回所有的value值数组
 
 @param dict dict description
 @return return value description
 */
- (NSArray *)valuesWithDict:(NSDictionary *)dict{
    NSMutableArray * values=[[NSMutableArray alloc]init];
    
    for (NSString * key in dict.allKeys) {
        [values addObject:dict[key]];
    }
    return values;
}


/**
 判断存在表内部函数

 @param queue 操作队列
 @param tableName 表名
 @return YES/NO
 */
- (BOOL)isExistTableInQueue:(FMDatabaseQueue*)queue withTableName:(NSString *)tableName
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



#pragma mark private method end

#pragma mark public method start

/**
 判断是否存在表

 @param dbname 库名
 @param tableName 表名
 @return YES/NO
 */
- (BOOL)isExistTableWithDBName:(NSString*)dbname withTableName:(NSString *)tableName
{
    FMDatabaseQueue* queue = [self getQueue:dbname];
    return [self isExistTableInQueue:queue withTableName:tableName];
    
}



#pragma mark create

/**
 创建表

 @param dbname 库名
 @param tableName 表名
 @param sql 创建表sql语句
 @return YES/NO
 */
-(BOOL)createTableWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSql:(NSString*)sql
{
    NSString *sqlString = [NSString stringWithFormat:sql, tableName];
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    return [self createTableWithQueue:queue withTableName:tableName withSQL:sqlString];

}

#pragma mark insert or replace

/**
 插入一个object实例入库，自动转换为数据集

 @param dbname 库名
 @param tableName 表名
 @param object 实体object
 @return YES/NO
 */
- (BOOL)insertWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andObject:(NSObject<AKDataObjectProtocol>*)object
{
    
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[object modelDBProperties];
    NSMutableString * str=[[NSMutableString alloc]init];
    NSMutableString * sql=[NSMutableString stringWithFormat:@"insert into %@(",tableName==nil? NSStringFromClass([object class]):tableName];
    for (int i=0;i<propertyArray.count;i++) {
        id value = [object valueForKey:propertyArray[i]];
        if(value){
            [valueArray addObject:value];
        }else{
            [valueArray addObject:@"NULL"];
        }
        if(i==0){
            [sql appendFormat:@"%@",propertyArray[i]];
            [str appendString:@"?"];
        }else{
            [sql appendFormat:@",%@",propertyArray[i]];
            [str appendString:@",?"];
        }
    }
    
    [sql appendFormat:@") values(%@);",str];
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    BOOL ok = [self excuteSQL:queue withSql:sql withArrParameter:valueArray];
    return ok;
}

/**
 插入或者替换单条记录集，指定sql语句

 @param dbname 库名
 @param tableName 表名
 @param sqlFormat sql语句
 @param object 实体object
 @return YES/NO
 */
- (BOOL)insertOrReplaceWithDBName:(NSString*)dbname withTableName:(NSString*)tableName withSqlFormat:(NSString*)sqlFormat andObject:(NSObject<AKDataObjectProtocol>*)object
{
    NSString *sqlString = [NSString stringWithFormat:sqlFormat, tableName];
    
    NSArray *arrPara = [object modelToDBRecord];
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    BOOL ok = [self excuteSQL:queue withSql:sqlString withArrParameter:arrPara];
    return ok;
    
}


/**
 插入或者替换单条记录集，自动获取sql语句

 @param dbname 库名
 @param tableName 表名
 @param object 实例object
 @return YES/NO
 */
- (BOOL)insertOrReplaceWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andObject:(NSObject<AKDataObjectProtocol>*)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[object modelDBProperties];
    NSMutableString * str=[[NSMutableString alloc]init];
    NSMutableString * sql=[NSMutableString stringWithFormat:@"replace into %@(",tableName==nil? NSStringFromClass([object class]):tableName];
    for (int i=0;i<propertyArray.count;i++) {
        id value = [object valueForKey:propertyArray[i]];
        if(value){
            [valueArray addObject:value];
        }else{
            [valueArray addObject:@"NULL"];
        }
        if(i==0){
            [sql appendFormat:@"%@",propertyArray[i]];
            [str appendString:@"?"];
        }else{
            [sql appendFormat:@",%@",propertyArray[i]];
            [str appendString:@",?"];
        }
    }
    
    [sql appendFormat:@") values(%@);",str];
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    
    BOOL ok = [self excuteSQL:queue withSql:sql withArrParameter:valueArray];
    return ok;
}


/**
 批量插入数据,失败回滚

 @param dbname 库名
 @param sqlFormat 表名
 @param dataArray 数据集数组
 @return YES/NO
 */
- (BOOL)insertDataArrayWithDBName:(NSString*)dbname withSqlFormat:(NSString *)sqlFormat withDataArray:(NSArray *)dataArray{
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
    if(queue){
        return [self excuteTransaction:queue withSql:sqlFormat withDataArray:dataArray];
    }
    
    return NO;
}

#pragma mark query


/**
 查询单个表所有数据集

 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例数组
 */
- (NSArray *)queryAllRowsWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass{
    
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM %@;",tableName?tableName:NSStringFromClass(aClass)];
    
    __block NSMutableArray *data = [[NSMutableArray alloc] init];

    FMDatabaseQueue* queue = [self getQueue:dbname];
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

/**
 查询单个表数据集,带查询参数，查询参数为空和queryAllRows效果一样
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例数组
 */
-(NSArray*)queryRowsByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params withModel:(Class)aClass
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
    
    FMDatabaseQueue* queue = [self getQueue:dbname];
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

/**
 查询单条数据,带查询参数
 
 @param dbname 库名
 @param tableName 表名
 @param aClass 反射生成类名
 @return 生成类实例
 */
-(AKBaseModel*)queryRowByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params withModel:(Class)aClass
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


#pragma mark update



/**
 更新数据集

 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @param attributes 更新属性
 @return YES/NO
 */
-(BOOL)updateByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params  withAttributes:(NSDictionary*)attributes
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




/**
 更新数据集，类名和表名可选填一个

 @param dbname 库名
 @param tableName 表名
 @param aClass 类名
 @param whereParams 查询参数
 @param params 更新参数
 @return YES/NO
 */
-(BOOL)updateWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass andWhereParams:(NSDictionary *)whereParams andParams:(NSDictionary *)params {
    NSString * sql;
    if(params&&params.allKeys){
        if(whereParams&&whereParams.allKeys){
            sql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@;",tableName?tableName:NSStringFromClass(aClass),[self setSqlWithDict:params],[self sqlWithDict:whereParams]];
            NSArray * paramArray=[self valuesWithDict:params];
            NSArray * tmpArray = [paramArray arrayByAddingObjectsFromArray:[self valuesWithDict:whereParams]];
            
            FMDatabaseQueue* queue = [self getQueue:dbname];
            if(queue){
                return [self excuteSQL:queue withSql:sql withArrParameter:tmpArray];
            }
        }else{
            sql=[NSString stringWithFormat:@"UPDATE %@ SET %@;",tableName?tableName:NSStringFromClass(aClass),[self setSqlWithDict:params]];
            
            FMDatabaseQueue* queue = [self getQueue:dbname];
            if(queue){
                return [self excuteSQL:queue withSql:sql withArrParameter:[self valuesWithDict:params]];
            }
        }
    }else{
        return YES;
    }
    return NO;
}


#pragma mark delete

/**
 删除数据集

 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @return YES/NO
 */
-(BOOL) deleteByParamsWithDBName:(NSString*)dbname withTableName:(NSString*)tableName andWhereParams:(NSDictionary*)params
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
/**
 删除数据集
 
 @param dbname 库名
 @param tableName 表名
 @param params 查询参数
 @return YES/NO
 */
-(BOOL) deleteByParamsWithDBName:(NSString*)dbname withTableName:(NSString *)tableName withModel:(Class)aClass andWhereParams:(NSDictionary *)params{
    NSString * sql;
    if(params&&params.allKeys){
        sql=[NSString stringWithFormat:@"delete from %@ where %@;",tableName?tableName:NSStringFromClass(aClass),[self sqlWithDict:params]];
        
        FMDatabaseQueue* queue = [self getQueue:dbname];
        return [self excuteSQL:queue withSql:sql withArrParameter:[self valuesWithDict:params]];

    }else{
        sql=[NSString stringWithFormat:@"delete from %@;",tableName?tableName:NSStringFromClass(aClass)];
        
        FMDatabaseQueue* queue = [self getQueue:dbname];
        return [self excuteSQL:queue withSql:sql];
    }
    
}





#pragma mark sqlite excute function


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


- (BOOL)excuteTransaction:(FMDatabaseQueue*)queue withSql:(NSString *)sqlString withDataArray:(NSArray*)dataArray
{
    __block BOOL ok = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        *rollback = NO;
        [db beginTransaction];//开始事务
        
        for (NSArray * paramArray in dataArray) {
            BOOL b = [db executeUpdate:sqlString withArgumentsInArray:paramArray];
            if (b==false) {
                [db rollback];
                *rollback = YES;
                ok = NO;
                NSLog(@"插入失败,执行数据回滚");
                return;
                
            }
        }
        
        [db commit];//提交事务
        ok = YES;
        
    }];
    
    return ok;
}

#pragma mark public method end

@end



