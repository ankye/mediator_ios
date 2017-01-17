//
//  BookDocument.h
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookDocument : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *userId;

+ (instancetype)bookDocumentWithDict:(NSDictionary *)dict;

@end

