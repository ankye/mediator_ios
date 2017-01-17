//
//  NSObject+Category.h
//  powerlife
//
//  Created by 陈行 on 16/7/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)
/**
 *  获取self的属性名，继承的父类不会包含在内
 */
+ (NSArray *)propertyNameArray;
- (NSArray *)propertyNameArray;

- (NSString *)otherDescription;

@end
