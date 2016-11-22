//
//  AKDataCenterObjectProtocol.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol AKDataCenterObjectProtocol <NSObject>


/**
 设置主键值
 
 @param key 唯一键值
 */
-(void)setKey:(NSString*)key;

/**
 获取主键
 
 @return 唯一键值
 */
-(NSString*)getKey;

/**
 填充数据，禁止直接覆盖
 @param object 填充数据
 */
-(void)fillData:(id<AKDataCenterObjectProtocol>)object;

@end


