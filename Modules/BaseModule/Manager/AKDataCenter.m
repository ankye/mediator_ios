//
//  AKDataCenter.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter.h"


#define KAK_FMDB_NAME @"AK_FMDB"

@interface AKDataCenter()

@property (nonatomic,strong) NSMutableDictionary* dataPools;



@end

@implementation AKDataCenter

SINGLETON_IMPL(AKDataCenter)


-(id)init
{
    self = [super init];
    if(self){
        _dataPools = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}


/**
 更新数据池，没有就创建一个空的数据池
 
 @param poolKey 数据Model类名，数据池键值
 @param key  数据唯一标识
 @param obj  数据内容
 @return 返回操作结果 YES or NO
 */
-(BOOL)updatePool:(NSString*)poolKey withKey:(NSString*)key andObject:(AKBaseModel*)obj
{
    NSMutableDictionary* pool = [self getPool:poolKey];
    
    AKBaseModel* object = [pool objectForKey:key];

    if(object == nil){
        object = obj;
        [pool setObject:obj forKey:key];
    }else{
        
        [object fillData:obj];
    }
    
    return YES;
}


/**
 获取单个数据池
 
 @param poolKey 数据Model类名，数据池键值
 @return 返回数据池字典
 */
-(NSMutableDictionary*)getPool:(NSString*)poolKey
{
    NSMutableDictionary* pool = [_dataPools objectForKey:poolKey];
    if(pool == nil){
        pool = [[NSMutableDictionary alloc] init];
        [_dataPools setObject:pool forKey:poolKey];
    }
    return pool;
}


/**
 从数据池取单个数据
 
 @param poolKey 数据Model类名，数据池键值
 @param key 单个数据键值
 @return 单个数据
 */
-(AKBaseModel*)getObjectFromPool:(NSString*)poolKey withKey:(NSString*)key
{
    NSMutableDictionary* pool = [self getPool:poolKey];
    AKBaseModel* object = [pool objectForKey:key];
    if(object == nil){
        object = [self createEmptyObjectForPool:poolKey withKey:key];
    }
    return object;
}


/**
 预创建一个空object

 @param poolKey 数据Model类名，数据池键值
 @param key 单个标识
 */
-(AKBaseModel*)createEmptyObjectForPool:(NSString*)poolKey withKey:(NSString*)key
{
    Class objClass = NSClassFromString(poolKey);
    AKBaseModel* object = [[objClass alloc] init];
    [object setKey:key];
    
    [self updatePool:poolKey withKey:key andObject:object];
    
    return object;
}

/**
 从数据池取多个数据
 
 @param poolKey 数据Model类名，数据池键值
 @param keys 多个数据键值数组
 @return 数据列表
 */
-(NSMutableArray*)getObjectsFromPool:(NSString*)poolKey withKeys:(NSArray*)keys
{
    if(keys == nil) return nil;
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    NSMutableDictionary* pool = [self getPool:poolKey];
    NSInteger keyCount = [keys count];
    for(NSInteger i=0; i<keyCount; i++){
        NSString* key = [keys objectAtIndex:i];
        id<AKDataCenterObjectProtocol> object = [pool objectForKey:key];
        if(object == nil){
            object = [self createEmptyObjectForPool:poolKey withKey:key];
        }
        
        [objects addObject:object];
    }
    return objects;
}

@end
