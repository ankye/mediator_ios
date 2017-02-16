//
//  BookCategory.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCategory : AKBaseModel
/**
 *  Id值
 */
@property (nonatomic, copy) NSString *Id;
/**
 *  key
 */
@property (nonatomic, copy) NSString *key;
/**
 *  数量
 */
@property (nonatomic, assign) NSInteger num;
/**
 *  类型
 */
@property (nonatomic, copy) NSString *name;
/**
 *  类型对应的url
 */
@property (nonatomic, copy) NSString *url;

+ (instancetype)bookCategoryWithDict:(NSDictionary *)dict;

@end
