//
//  AKDataCenter.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"
#import "AKBaseModel.h"

#define AK_DATA_CENTER [AKDataCenter sharedInstance]

@interface AKDataCenter : NSObject

SINGLETON_INTR(AKDataCenter)


/**
 更新数据池，没有就创建一个空的数据池

 @param poolKey 数据Model类名，数据池键值
 @param key  数据唯一标识
 @param obj  数据内容
 @return 返回操作结果 YES or NO
 */
-(BOOL)updatePool:(NSString*)poolKey withKey:(NSString*)key andObject:(AKBaseModel*)obj;


/**
 获取单个数据池

 @param poolKey 数据Model类名，数据池键值
 @return 返回数据池字典
 */
-(NSMutableDictionary*)getPool:(NSString*)poolKey;


/**
 从数据池取单个数据

 @param poolKey 数据Model类名，数据池键值
 @param key 单个数据键值
 @return 单个数据
 */
-(AKBaseModel*)getObjectFromPool:(NSString*)poolKey withKey:(NSString*)key;


/**
 从数据池取多个数据

 @param poolKey 数据Model类名，数据池键值
 @param keys 多个数据键值数组
 @return 数据列表
 */
-(NSMutableArray*)getObjectsFromPool:(NSString*)poolKey withKeys:(NSArray*)keys;

@end
