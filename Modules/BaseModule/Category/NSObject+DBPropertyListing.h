//
//  NSObject+PropertyListing.h
//  LTDemo
//
//  Created by PeteOu on 16/8/9.
//  Copyright © 2016年 PeteOu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 不同变量类型的Attributes的开头，具体可调用fetchPropertyAttributes方法来看看
 */
#define kPropertyAttrString @"T@\"NSString\""
#define kPropertyAttrNumber @"T@\"NSNumber\""
#define kPropertyAttrShort @"Ts"
#define kPropertyAttrFloat @"Tf"
#define kPropertyAttrLong @"Tq"

@interface NSObject (DBPropertyListing)

/**
 *  获取所有属性字段
 *
 *  @return  数组
 */
- (NSArray *)fetchPropertyList;

/**
 *  获取所有属性的属性
 *
 *  @return  数组
 */
- (NSArray *)fetchPropertyAttributes;

/**
 *  获取所有属性字段
 *  针对DBBaseObject
 *
 *  @return  数组
 */
- (NSArray *)fetchDBObjectPropertyList;

/**
 *  获取所有属性的属性
 *  针对DBBaseObject
 *
 *  @return  数组
 */
- (NSArray *)fetchDBObjectPropertyAttributes;

@end
