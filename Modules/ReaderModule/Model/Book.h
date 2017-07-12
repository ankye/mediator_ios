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
#import "BookChapter.h"

typedef enum : NSUInteger {
    BOOK_CACHE_STATUS_NONE,
    BOOK_CACHE_STATUS_ING,
    BOOK_CACHE_STATUS_ALL_END,
} BOOK_CACHE_STATUS;

@interface Book : ALModel

@property (nonatomic, strong) BookAuthor *author;

@property (nonatomic, strong) BookCategory *category;

@property (nonatomic, strong) BookSource *source;

@property (nonatomic, strong) BookNovel *novel;

@property (nonatomic, strong) BookLastUpdate *last;

@property (nonatomic, strong) BookEveryUrl *url;

//本地数据
@property (nonatomic, assign) BOOL isLoadLocal;

//section代表章节，row代表章节的第几行
@property (nonatomic, assign) NSInteger read_chapter_section;
@property (nonatomic, assign) NSInteger read_chapter_row;

@property (nonatomic, assign) NSInteger download_chapter_section;
@property (nonatomic, assign) NSInteger download_chapter_row;

@property (nonatomic, assign) BOOL hasSticky;       //置顶
@property (nonatomic, assign) NSInteger extType;    //扩展类型
@property (nonatomic, assign) BOOL isBookmark;         //是否收藏
@property (nonatomic, assign) BOOK_CACHE_STATUS  bookCacheStatus; //缓存状态

//章节列表变更
@property (nonatomic, readwrite) UBSignal<MutableArraySignal> *onChaptersChange;
@property (nonatomic, strong) NSMutableArray<BookChapter *> * bookChapters; //章节列表


+ (instancetype)bookWithDict:(NSDictionary *)dict;

- (void)refreshBasicData;

@end

