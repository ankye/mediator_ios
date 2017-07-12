//
//  AKDataCenter.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDataCenter.h"


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
 
 @param groupKey 数据组名，数据池键值
 @param key  数据唯一标识
 @param obj  数据内容
 @return 返回操作结果 YES or NO
 */
-(BOOL)set:(NSString*)groupKey withKey:(NSString*)key andObject:(ALModel*)obj
{
    NSMutableDictionary* group = [self getGroup:groupKey];

//    if([obj respondsToSelector:@selector(fillData)]){
//        ALModel* object = [group objectForKey:key];
//        if(object == nil){
//            object = obj;
//            [group setObject:object forKey:key];
//        }else{
//            
//            [object fillData:obj];
//        }
//    }else{
//        [group setObject:obj forKey:key];
//    }
//   //

    [group setObject:obj forKey:key];
    
    
    return YES;
}


/**
 获取单个数据池
 
 @param groupKey 数据组名，数据池键值
 @return 返回数据池字典
 */
-(NSMutableDictionary*)getGroup:(NSString*)groupKey
{
    NSMutableDictionary* group = [_dataPools objectForKey:groupKey];
    if(group == nil){
        group = [[NSMutableDictionary alloc] init];
        [_dataPools setObject:group forKey:groupKey];
    }
    return group;
}


/**
 从数据池取单个数据
 
 @param groupKey 数据组名，数据池键值
 @param key 单个数据键值
 @return 单个数据
 */
-(ALModel*)get:(NSString*)groupKey withKey:(NSString*)key
{
    NSMutableDictionary* group = [self getGroup:groupKey];
    ALModel* object = [group objectForKey:key];
    if(object == nil){
        object = [self createEmptyObjectForGroup:groupKey withKey:key];
    }
    return object;
}


/**
 预创建一个空object

 @param groupKey 数据组名，数据池键值
 @param key 单个标识
 */
-(ALModel*)createEmptyObjectForGroup:(NSString*)groupKey withKey:(NSString*)key
{
    Class objClass = NSClassFromString(groupKey);
    ALModel* object = [[objClass alloc] init];
   
    [self set:groupKey withKey:key andObject:object];
    
    return object;
}

/**
 从数据池取多个数据
 
 @param groupKey 数据组名，数据池键值
 @param keys 多个数据键值数组
 @return 数据列表
 */
-(NSMutableArray*)getObjectsFromGroup:(NSString*)groupKey withKeys:(NSArray*)keys
{
    if(keys == nil) return nil;
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    NSMutableDictionary* group = [self getGroup:groupKey];
    NSInteger keyCount = [keys count];
    for(NSInteger i=0; i<keyCount; i++){
        NSString* key = [keys objectAtIndex:i];
        ALModel* object = [group objectForKey:key];
        if(object == nil){
            object = [self createEmptyObjectForGroup:groupKey withKey:key];
        }
        
        [objects addObject:object];
    }
    return objects;
}

@end
