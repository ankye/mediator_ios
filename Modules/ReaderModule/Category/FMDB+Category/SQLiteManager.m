//
//  SQLiteManager.m
//  比颜值
//
//  Created by 陈行 on 15-12-1.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "SQLiteManager.h"
#import <objc/runtime.h>

static SQLiteManager * manager;

@interface SQLiteManager()

@property(nonatomic,strong)FMDatabase * db;

@property(nonatomic,strong)FMResultSet * rs;

@property(nonatomic,copy)NSString * appVersion;

@property(nonatomic,copy)NSString * databaseVersion;

@end

@implementation SQLiteManager

/**
 *  单例
 *
 *  @return SQLiteManager对象
 */
+ (SQLiteManager *)shareSQLiteManagerWithDatabasePath:(NSString *)databasePath{
    [self shareSQLiteManager];
    manager.databasePath=databasePath;
    return manager;
}

+ (SQLiteManager *)shareSQLiteManager{
    if(manager==nil){
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            manager=[[SQLiteManager alloc]init];
            manager.databasePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),DATABASE_PATH];
        });
    }
    return manager;
}

/**
 *  创建一张表
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)createTableWithSQL:(NSString *)sql{
    return [self DMLSQL:sql andArgumentsInArray:nil];
}

/**
 *  以下四个，增(or替换)删改
 *
 *  @param sql sql语句
 *
 *  @return 成功or失败
 */
- (BOOL)insertWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)insertOrReplaceWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)updateWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}

- (BOOL)deleteWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    return [self DMLSQL:sql andArgumentsInArray:array];
}
/**
 *  统一执行增加(或替换)删除修改操作
 *
 *  @param sql   sql语句
 *  @param array 参数
 *
 *  @return 成功or失败
 */
- (BOOL)DMLSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    [self openDatabase];
    NSMutableArray * tmpArray=[NSMutableArray arrayWithArray:array];
    for(int i=0;i<tmpArray.count;i++){
        NSString * str=tmpArray[i];
        if([[NSString class] isSubclassOfClass:[str class]] && str.length==0){
            tmpArray[i]=@"NULL";
        }
    }
    
    BOOL b=[self.db executeUpdate:sql withArgumentsInArray:tmpArray];
    [self closeDatabase];
    return b;
}
/**
 *  查询
 *
 *  @param sql   sql语句
 *  @param array 参数
 */
- (FMResultSet *)queryWithSQL:(NSString *)sql andArgumentsInArray:(NSArray *)array{
    [self openDatabase];
    self.rs=[self.db executeQuery:sql withArgumentsInArray:array];
    return self.rs;
}

+ (BOOL)insertToTableName:(NSString *)tableName andObject:(id)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[self propertyArrayWithClass:[object class]];
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
    
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:sql andArgumentsInArray:valueArray];
}

+ (BOOL)insertWithNoArrayToTableName:(NSString *)tableName andObject:(id)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[self propertyArrayWithClass:[object class]];
    NSMutableString * str=[[NSMutableString alloc]init];
    NSMutableString * sql=[NSMutableString stringWithFormat:@"insert into %@(",tableName==nil? NSStringFromClass([object class]):tableName];
    BOOL b = false;
    for (int i=0;i<propertyArray.count;i++) {
        id value = [object valueForKey:propertyArray[i]];
        if([value isKindOfClass:[NSArray class]]){
            if (i==0) {
                b=true;
            }
            continue;
        }
        if(value){
            [valueArray addObject:value];
        }else{
            [valueArray addObject:@"NULL"];
        }
        if(b){
            b=false;
            [sql appendFormat:@"%@",propertyArray[i]];
            [str appendString:@"?"];
            continue;
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
    
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:sql andArgumentsInArray:valueArray];
}

+ (BOOL)insertOrReplaceWithNoArrayToTableName:(NSString *)tableName andObject:(id)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[self propertyArrayWithClass:[object class]];
    NSMutableString * str=[[NSMutableString alloc]init];
    NSMutableString * sql=[NSMutableString stringWithFormat:@"replace into %@(",tableName==nil? NSStringFromClass([object class]):tableName];
    BOOL b = false;
    for (int i=0;i<propertyArray.count;i++) {
        id value = [object valueForKey:propertyArray[i]];
        if([value isKindOfClass:[NSArray class]]){
            if (i==0) {
                b=true;
            }
            continue;
        }
        if(value){
            [valueArray addObject:value];
        }else{
            [valueArray addObject:@"NULL"];
        }
        if(b){
            b=false;
            [sql appendFormat:@"%@",propertyArray[i]];
            [str appendString:@"?"];
            continue;
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
    
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:sql andArgumentsInArray:valueArray];
}

+ (BOOL)insertOrReplaceToTableName:(NSString *)tableName andObject:(id)object{
    NSMutableArray * valueArray=[[NSMutableArray alloc]init];
    
    NSArray * propertyArray=[self propertyArrayWithClass:[object class]];
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
    
    return [[SQLiteManager shareSQLiteManager]insertWithSQL:sql andArgumentsInArray:valueArray];
}

+ (BOOL)insertToTableWithDataArray:(NSArray *)dataArray andSQL:(NSString *)sql{
    FMDatabase * db = [SQLiteManager shareSQLiteManager].db;
    [db open];
    [db beginTransaction];
    BOOL res=true;
    
    @try {
        for (NSArray * paramArray in dataArray) {
            BOOL b = [db executeUpdate:sql withArgumentsInArray:paramArray];
            if (b==false) {
                res=false;
                NSLog(@"插入失败1");
            }
        }
    } @catch (NSException *exception) {
        res=false;
        [db rollback];
    } @finally {
        if (res==true) {
            [db commit];
        }
        [db close];
    }
    return res;
}

+ (NSArray *)queryAllWithTableName:(NSString *)tableName andClass:(Class)clazz{
    NSArray * propertyArray=[self propertyArrayWithClass:clazz];
    NSMutableArray * dataArray=[[NSMutableArray alloc]init];
    
    NSString * sql=[NSString stringWithFormat:@"select * from %@;",tableName?tableName:NSStringFromClass(clazz)];
    FMResultSet * rs = [[self shareSQLiteManager] queryWithSQL:sql andArgumentsInArray:nil];
    while (rs.next) {
        id obj=[[clazz alloc]init];
        for (NSString * prop in propertyArray) {
            if(![rs columnIsNull:prop]){
                id value = [rs objectForColumnName:prop];
                if(value && ![[NSString stringWithFormat:@"%@",value] isEqualToString:@"NULL"]){
                    [obj setValue:value forKey:prop];
                }
            }
        }
        [dataArray addObject:obj];
    }
    [rs close];
    return dataArray;
}

+ (NSArray *)queryByParamsWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params{
    NSArray * propertyArray=[self propertyArrayWithClass:clazz];
    NSMutableArray * dataArray=[[NSMutableArray alloc]init];
    
    NSString * sql=[NSString stringWithFormat:@"select * from %@;",tableName?tableName:NSStringFromClass(clazz)];
    
    FMResultSet * rs;
    
    if(params&&params.allKeys){
        sql=[NSString stringWithFormat:@"select * from %@ where %@;",tableName?tableName:NSStringFromClass(clazz),[self sqlWithDict:params]];
        rs=[[self shareSQLiteManager] queryWithSQL:sql andArgumentsInArray:[self valuesWithDict:params]];
    }else{
        rs=[[self shareSQLiteManager] queryWithSQL:sql andArgumentsInArray:nil];
    }
    
    
    while (rs.next) {
        id obj=[[clazz alloc]init];
        for (NSString * prop in propertyArray) {
            if(![rs columnIsNull:prop]){
                id value = [rs objectForColumnName:prop];
                if(value && ![[NSString stringWithFormat:@"%@",value] isEqualToString:@"NULL"]){
                    [obj setValue:value forKey:prop];
                }
            }
        }
        [dataArray addObject:obj];
    }
    [rs close];
    return dataArray;
}

+ (BOOL)deleteWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params{
    NSString * sql;
    if(params&&params.allKeys){
        sql=[NSString stringWithFormat:@"delete from %@ where %@;",tableName?tableName:NSStringFromClass(clazz),[self sqlWithDict:params]];
        return [[self shareSQLiteManager]deleteWithSQL:sql andArgumentsInArray:[self valuesWithDict:params]];
    }else{
        sql=[NSString stringWithFormat:@"delete from %@;",tableName?tableName:NSStringFromClass(clazz)];
        return [[self shareSQLiteManager]deleteWithSQL:sql andArgumentsInArray:nil];
    }
}

+ (BOOL)updateWithTableName:(NSString *)tableName andClass:(Class)clazz andParams:(NSDictionary *)params andWhereParams:(NSDictionary *)whereParams{
    NSString * sql;
    if(params&&params.allKeys){
        if(whereParams&&whereParams.allKeys){
            sql=[NSString stringWithFormat:@"update %@ set %@ where %@;",tableName?tableName:NSStringFromClass(clazz),[self setSqlWithDict:params],[self sqlWithDict:whereParams]];
            NSArray * paramArray=[self valuesWithDict:params];
            NSArray * tmpArray = [paramArray arrayByAddingObjectsFromArray:[self valuesWithDict:whereParams]];
            
            return [[self shareSQLiteManager]updateWithSQL:sql andArgumentsInArray:tmpArray];
        }else{
            sql=[NSString stringWithFormat:@"update %@ set %@;",tableName?tableName:NSStringFromClass(clazz),[self setSqlWithDict:params]];
            return [[self shareSQLiteManager]updateWithSQL:sql andArgumentsInArray:[self valuesWithDict:params]];
        }
    }else{
        return true;
    }
}
/**
 *  根据字典参数拼接出key1=? , key2=?
 *
 *  @param dict
 *
 *  @return key1=? and key2=?
 */
+ (NSString *)setSqlWithDict:(NSDictionary *)dict{
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
 *  根据字典参数拼接出key1=? and key2=?
 *
 *  @param dict
 *
 *  @return key1=? and key2=?
 */
+ (NSString *)sqlWithDict:(NSDictionary *)dict{
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
 *  返回所有的value值数组
 *
 *  @param dict
 *
 *  @return
 */
+ (NSArray *)valuesWithDict:(NSDictionary *)dict{
    NSMutableArray * values=[[NSMutableArray alloc]init];
    
    for (NSString * key in dict.allKeys) {
        [values addObject:dict[key]];
    }
    return values;
}

+ (NSArray *)propertyArrayWithClass:(Class)clazz{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    
    for(int i=0;i<count;i++){
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        [array addObject:name];
    }
    free(pros);
    return array;
}

/**
 *  检查数据库，是否需要更新
 *
 *  @return
 */
+ (void)checkAndUpdateDatabaseVersion{
    
    //判断文件是否已经copy到沙盒目录中
    [self moveDatabaseFileToHomeDirectory];
    
    SQLiteManager * manager= [self shareSQLiteManager];
    //获取ipa中的版本信息，
    manager.appVersion=[InitialData sharedInitialData].appVersion;
    //设置数据库文件地址
    NSString * databasePath=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),DATABASE_PATH];
    manager.databasePath=databasePath;
    
    //获取本地文件，取得数据库版本
    manager.databasePath=databasePath;
    NSString * sql=@"select * from setting;";
    FMResultSet * rs = [manager queryWithSQL:sql andArgumentsInArray:nil];
    if(rs.next){
        manager.databaseVersion = [rs stringForColumn:@"database_version"];
    }
    [rs close];
    //看数据库版本与app版本是否一致，不一致更新
    if(![manager.databaseVersion isEqualToString:manager.appVersion]){
        [manager updateDatabase];
    }
}

-(void)updateDatabase{
    if([self.databaseVersion isEqualToString:VERSION_0]){
        NSLog(@"进行首次安装");
        self.databaseVersion=VERSION_1_1_1;
    }
    
    
    [SQLiteManager updateWithTableName:@"setting" andClass:nil andParams:@{@"database_version":self.databaseVersion} andWhereParams:nil];
}

/**
 *  打开数据库
 *
 *  @return 成功or失败
 */
- (BOOL)openDatabase{
    
    if(![self.db open]){
        NSLog(@"打开数据库失败");
        return false;
    }
    return true;
}

/**
 *  关闭数据库
 *  释放sql文
 *  设置为没有正在执行sql文
 */
- (void)closeDatabase{
    if(self.rs){
        [self.rs close];
    }
    [self.db close];
}

/**
 *  懒加载
 *
 *  @return 
 */
- (FMDatabase *)db{
    if(_db==nil){
        _db=[FMDatabase databaseWithPath:self.databasePath];
    }
    return _db;
}

/**
 *  copy数据库到沙盒目录中
 */
+ (void)moveDatabaseFileToHomeDirectory{
    NSString * databasePath=[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),DATABASE_PATH];
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString * filePath = [[NSBundle mainBundle]pathForResource:@"database.sqlite3" ofType:nil];
        [fileManager copyItemAtPath:filePath toPath:databasePath error:nil];
    }
}

@end
