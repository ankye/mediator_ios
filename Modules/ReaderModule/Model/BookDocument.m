//
//  BookDocument.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDocument.h"
#import "MJExtension.h"

@implementation BookDocument

+ (instancetype)bookDocumentWithDict:(NSDictionary *)dict{
    return [self mj_objectWithKeyValues:dict];
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    return [propertyName mj_underlineFromCamel];
}

@end


