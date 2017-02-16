//
//  BookCategory.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCategory.h"
#import "MJExtension.h"

@implementation BookCategory

+ (instancetype)bookCategoryWithDict:(NSDictionary *)dict{
    return  [self mj_objectWithKeyValues:dict];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

-(void)fillData:(id<AKDataObjectProtocol>)object
{
    BookCategory* temp = (BookCategory*)object;
    self.Id = temp.Id;
    self.key = temp.key;
    self.num = temp.num;
    self.name = temp.name;
    self.url = temp.url;
}
@end
