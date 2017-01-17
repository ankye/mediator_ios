//
//  BookDatabase.h
//  quread
//
//  Created by 陈行 on 16/11/4.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookDatabase : NSObject

@property (nonatomic, copy) NSString *novel_id;
@property (nonatomic, copy) NSString *novel_cover;
@property (nonatomic, copy) NSString *novel_name;
@property (nonatomic, copy) NSString *novel_intro;
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, copy) NSString *lastupdate_chapter_time;
@property (nonatomic, copy) NSString *lastupdate_chapter_name;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, assign) NSInteger read_chapter_section;
@property (nonatomic, assign) NSInteger read_chapter_row;
@property (nonatomic, copy) NSString *source_siteid;

+ (BOOL)saveBookToDataBaseWithIndexPath:(NSIndexPath *)indexPath andBook:(Book *)book;

+ (NSArray<Book *> *)bookDataListFromDatabaseWithNovelId:(NSString *)novelId;

+ (BOOL)removeBookDataFromDatabaseWithNovelId:(NSString *)novelId;


@end
