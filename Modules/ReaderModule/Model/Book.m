//
//  Book.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "Book.h"
#import "MJExtension.h"
#import "NSString+Category.h"
#import "NSDate+Time.h"

#import "SQLiteManager.h"

@implementation Book

+ (instancetype)bookWithDict:(NSDictionary *)dict{
    
    Book * book = [self mj_objectWithKeyValues:dict];
    [book refreshBasicData];
    return book;
}

- (void)refreshBasicData{
    
    if (self.novel.intro.length) {
        self.novel.introHeight = [self.novel.intro heightWithFontSize:13 andWidth:(WIDTH-20)];
    }
    
    if (self.last.time.length) {
        self.last.timeName = [NSDate getCustomTimeByCurrentTimeStrWithTimeInterval:[self.last.time integerValue]];
    }
    
    if (self.novel.cover.length && ![self.novel.cover hasPrefix:@"http"]) {
        self.novel.cover = [NSString stringWithFormat:@"%@%@",SERVER_URL,self.novel.cover];
    }
    
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"author":NSStringFromClass([BookAuthor class]),
             @"category":NSStringFromClass([BookCategory class]),
             @"source":NSStringFromClass([BookSource class]),
             @"novel":NSStringFromClass([BookNovel class]),
             @"last":NSStringFromClass([BookLastUpdate class]),
             };
}

@end


