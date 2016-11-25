//
//  DBBaseObject.h
//  LTDemo
//
//  Created by PeteOu on 16/8/9.
//  Copyright © 2016年 PeteOu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DBPropertyListing.h"

@interface DBBaseObject : NSObject

/**
 *  继承这个“数据库模型”基础类，适用于与DataBaseManager相关方法结合使用
 @note 这是自增id，作为主键使用，子类不需要进行赋值或修改
 */
@property (nonatomic, assign) NSInteger pk_cid;

@end
