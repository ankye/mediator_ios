//
//  AKDataCenter.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"
#import "ALModel+ActiveRecord.h"

#define AK_DATA_CENTER [AKDataCenter sharedInstance]

@interface AKDataCenter : NSObject

SINGLETON_INTR(AKDataCenter)


/**
 更新数据池，没有就创建一个空的数据池

 @param groupKey 数据组名，数据池键值
 @param key  数据唯一标识
 @param obj  数据内容
 @return 返回操作结果 YES or NO
 */
-(BOOL)set:(NSString*)groupKey withKey:(NSString*)key andObject:(ALModel*)obj;


/**
 获取单个数据池

 @param group 数据组名，数据池键值
 @return 返回数据池字典
 */
-(NSMutableDictionary*)getGroup:(NSString*)group;


/**
 从数据池取单个数据

 @param groupKey 数据组名，数据池键值
 @param key 单个数据键值
 @return 单个数据
 */
-(ALModel*)get:(NSString*)groupKey withKey:(NSString*)key;


/**
 从数据池取多个数据

 @param groupKey 数据组名，数据池键值
 @param keys 多个数据键值数组
 @return 数据列表
 */
-(NSMutableArray*)getObjectsFromGroup:(NSString*)groupKey withKeys:(NSArray*)keys;

@end
