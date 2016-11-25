//
//  DataBaseManager.m
//  LTDemo
//
//  Created by PeteOu on 16/8/6.
//  Copyright © 2016年 PeteOu. All rights reserved.
//

#import "DataBaseManager.h"
#import "DBBaseObject.h"
#import <FMDB/FMDB.h>
#import <objc/runtime.h>

#import "NSString+Tools.h"

@interface DataBaseManager ()
/**
 *  FMDataBaseQueue的实例
 */
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
/**
 *  GCD的queue，定义为串行队列，因为fmdb本身的队列也是串行的，所以这个定义为串行的问题不大，反而更贴合实际应用场景，因为有时候是先插入数据再进行查询数据，那么就要保持一定的顺序性
 */
@property (nonatomic, strong) dispatch_queue_t dbGCDQueue;
@end

@implementation DataBaseManager

static DataBaseManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.dbGCDQueue = dispatch_queue_create("DataBaseManager", NULL);
        
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DBName];
        
        _instance.dbQueue = [[FMDatabaseQueue alloc] initWithPath:filename];//建库
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark -

- (void)createTableForModelClass:(Class)mClass{
    NSAssert([mClass isSubclassOfClass:[DBBaseObject class]], @"录入数据库的模型，必须要继承DBBaseObject！");
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
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
        
        [db executeStatements:sql];
    }];
}

- (void)querySomething:(NSString *)sqlString withBlock:(dbQueryResultBlock)block{
    dispatch_async(self.dbGCDQueue, ^{
        //做了些数据库操作，然后完成之后，就使用主线程调用block
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO, nil);
            });
        }
    });
}

- (void)queryWithSql:(NSString *)sqlString withBlock:(dbQueryResultBlock)block toModelClass:(Class)mClass{
    __block NSMutableArray *modelArray = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
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
                // 值是从我们的数据表的Column字段取出来，
                
                //判断属性的是什么类型，那么获取的方法也不一样
                if ([attrs[i] startWithSubString:kPropertyAttrString]) {
                    [model setValue:[resultSet stringForColumn:keys[i]] forKey:keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrShort] || [attrs[i] startWithSubString:kPropertyAttrLong]) {
                    [model setValue:@([resultSet intForColumn:keys[i]]) forKey:keys[i]];
                }else if ([attrs[i] startWithSubString:kPropertyAttrFloat]) {
                    [model setValue:@([resultSet doubleForColumn:keys[i]]) forKey:keys[i]];
                }else{
                    [model setValue:[resultSet stringForColumn:keys[i]] forKey:keys[i]];
                }
                
            }
            [modelArray addObject:model];
        }
    }];
    
    dispatch_async(self.dbGCDQueue, ^{
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, modelArray);
            });
        }
    });
}

- (void)queryAllToModelClass:(Class)mClass withBlock:(dbQueryResultBlock)block{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass(mClass)];
    [self queryWithSql:sqlString withBlock:block toModelClass:mClass];
}

- (void)insertOrUpdateModel:(id)model withBlock:(dbUpdateResultBlock)block{
    //TODO:1
}

- (void)insertModels:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block{
    __block BOOL result = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        
        if (modelArray.count == 0) {
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@", NSStringFromClass([[modelArray objectAtIndex:0] class])];
        NSArray *keys = [[modelArray objectAtIndex:0] fetchDBObjectPropertyList];
        [sql appendFormat:@" ("];
        for (int i =0; i< keys.count; i++) {
            if ([keys[i] isEqualToString:@"pk_cid"]) {
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
            [sql appendFormat:@" ?,"];
        }
        if ([[sql substringWithRange:NSMakeRange(sql.length - 1, 1)] isEqualToString:@","]) {
            sql = [[sql substringToIndex:sql.length - 1] mutableCopy];
        }
        [sql appendFormat:@" )"];
        NSLog(@"--sql: -->%@",sql);
        
        for (int k = 0; k < modelArray.count; k++) {
            id model = [modelArray objectAtIndex:k];
            NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i = 0; i < keys.count; i++) {
                if ([keys[i] isEqualToString:@"pk_cid"]) {
                    continue;
                }
                
                [arguments addObject:[model valueForKey:keys[i]]];
            }
            [db executeUpdate:sql withArgumentsInArray:arguments];
        }
        
        
    }];
    
    dispatch_async(self.dbGCDQueue, ^{
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}

- (void)updateModels:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block{
    __block BOOL result = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        
        if (modelArray.count == 0) {
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@", NSStringFromClass([[modelArray objectAtIndex:0] class])];
        NSArray *keys = [[modelArray objectAtIndex:0] fetchDBObjectPropertyList];
        [sql appendFormat:@" SET"];
        for (int i =0; i< keys.count; i++) {
            if ([keys[i] isEqualToString:@"pk_cid"]) {
                continue;
            }
            [sql appendFormat:@" %@ = ?,",keys[i]];
        }
        if ([[sql substringWithRange:NSMakeRange(sql.length - 1, 1)] isEqualToString:@","]) {
            sql = [[sql substringToIndex:sql.length - 1] mutableCopy];
        }
        [sql appendFormat:@" WHERE pk_cid = ?"];
        NSLog(@"--sql: -->%@",sql);
        
        for (int k = 0; k < modelArray.count; k++) {
            id model = [modelArray objectAtIndex:k];
            NSMutableArray *arguments = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i = 0; i < keys.count; i++) {
                if ([keys[i] isEqualToString:@"pk_cid"]) {
                    continue;
                }
                
                [arguments addObject:[model valueForKey:keys[i]]];
            }
            [arguments addObject:[model valueForKey:@"pk_cid"]];
            [db executeUpdate:sql withArgumentsInArray:arguments];
        }
        
        
    }];
    
    dispatch_async(self.dbGCDQueue, ^{
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}

- (void)insertOrUpdateModelArray:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
    }];
    //TODO:2
}

- (void)deleteModel:(id)model withBlock:(dbUpdateResultBlock)block{
    __block BOOL result = YES;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }
        
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE pk_cid = ?", NSStringFromClass([model class])];
        result = [db executeUpdate:sql withArgumentsInArray:@[[model valueForKey:@"pk_cid"]]];
    }];
    
    dispatch_async(self.dbGCDQueue, ^{
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}

- (void)deleteModelArray:(NSMutableArray *)modelArray withBlock:(dbUpdateResultBlock)block{
    __block BOOL result = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
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
    
    dispatch_async(self.dbGCDQueue, ^{
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}


#pragma mark - 测试的
- (void)test1{
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *dropSql = @"DROP TABLE IF EXISTS DBExampleObject";
//        [db executeStatements:dropSql];
//    }];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = @"delete from DBExampleObject";
        [db executeStatements:deleteSql];
    }];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i < 5000; i++) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%d', '%f')",
                                   @"DBExampleObject", @"name", @"age", @"height", @"Peter", i, 175.0];
            [db executeUpdate:insertSql];
        }
    }];
}

- (void)example{
    //建表
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *dropSql = @"DROP TABLE IF EXISTS t_person";
        [db executeStatements:dropSql];
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY, name text NOT NULL, age integer);";
        [db executeStatements:sql];
    }];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i < 5000; i++) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%d', '%@', '%d')",
                                    @"t_person", @"id", @"name", @"age", i, @"Peter", i];
            [db executeUpdate:insertSql];
        }
    }];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_person"];
        while ([rs next]) {
        //    int index = [rs intForColumnIndex:0];
//            NSLog(@"%d",index);
        }
    }];
}

- (void)example2{
    //建表
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *dropSql = @"DROP TABLE IF EXISTS t_animal";
        [db executeStatements:dropSql];
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_animal (id integer PRIMARY KEY, name text NOT NULL, age integer);";
        [db executeStatements:sql];
    }];
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 10000; i < 15000; i++) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%d', '%@', '%d')",
                                   @"t_animal", @"id", @"name", @"age", i, @"Peter", i];
            [db executeUpdate:insertSql];
        }
    }];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_animal"];
        while ([rs next]) {
       //     int index = [rs intForColumnIndex:0];
//            NSLog(@"--%d",index);
        }
    }];
}

- (void)example3{
    double start = CFAbsoluteTimeGetCurrent();
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 10000; i < 15000; i++) {
            NSString *updatetSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = %d",
                                   @"t_animal", @"name", @"John", @"id", i];
            [db executeUpdate:updatetSql];
        }
    }];
    NSLog(@"消耗时间%f", CFAbsoluteTimeGetCurrent() - start);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM t_animal"];
        while ([rs next]) {
       //     NSString *name = [rs stringForColumnIndex:1];
//            NSLog(@"%@",name);
        }
    }];
}


@end
