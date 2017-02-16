//
//  Book.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookLastUpdate.h"
#import "BookEveryUrl.h"
#import "BookCategory.h"
#import "BookSource.h"
#import "BookAuthor.h"
#import "BookNovel.h"

typedef enum : NSUInteger {
    BOOK_CACHE_STATUS_NONE,
    BOOK_CACHE_STATUS_ING,
    BOOK_CACHE_STATUS_ALL_END,
} BOOK_CACHE_STATUS;

@interface Book : AKBaseModel

@property (nonatomic, strong) BookAuthor *author;

@property (nonatomic, strong) BookCategory *category;

@property (nonatomic, strong) BookSource *source;

@property (nonatomic, strong) BookNovel *novel;

@property (nonatomic, strong) BookLastUpdate *last;

@property (nonatomic, strong) BookEveryUrl *url;

@property (nonatomic, assign) NSInteger read_chapter_section;
@property (nonatomic, assign) NSInteger read_chapter_row;

@property (assign, nonatomic) BOOL hasSticky;       //置顶
@property (assign, nonatomic) BOOL hasUpdated;      //有更新
@property (assign, nonatomic) NSInteger extType;    //扩展类型

@property(nonatomic,strong) NSDictionary * data;
/**
 *  缓存的下标，
 */
@property(nonatomic,strong)NSIndexPath * currIndexPath;
/**
 *  是否收藏
 */
@property(nonatomic,assign)BOOL isCaseBook;
/**
 *  缓存状态
 */
@property (nonatomic, assign) BOOK_CACHE_STATUS bookCacheStatus;

+ (instancetype)bookWithDict:(NSDictionary *)dict;

- (void)refreshBasicData;

@end

