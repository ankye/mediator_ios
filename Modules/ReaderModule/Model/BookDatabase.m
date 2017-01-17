//
//  BookDatabase.m
//  quread
//
//  Created by 陈行 on 16/11/4.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDatabase.h"
#import "SQLiteManager.h"
#import "NSDate+Time.h"

@implementation BookDatabase

+ (BOOL)saveBookToDataBaseWithIndexPath:(NSIndexPath *)indexPath andBook:(Book *)book{
    
    BookDatabase * bookDatabase = [[self alloc]init];
    
    bookDatabase.novel_id = book.novel.Id;
    bookDatabase.novel_cover = book.novel.cover;
    bookDatabase.novel_name = book.novel.name;
    bookDatabase.novel_intro = book.novel.intro;
    bookDatabase.author_name = book.author.name;
    bookDatabase.lastupdate_chapter_time = book.last.time;
    bookDatabase.lastupdate_chapter_name = book.last.name;
    bookDatabase.category_id = book.category.Id;
    bookDatabase.category_name = book.category.name;
    bookDatabase.read_chapter_section = indexPath.section;
    bookDatabase.read_chapter_row = indexPath.row;
    bookDatabase.source_siteid = book.source.siteid;
    
    return [SQLiteManager insertOrReplaceToTableName:@"book" andObject:bookDatabase];
}

+ (NSArray<Book *> *)bookDataListFromDatabaseWithNovelId:(NSString *)novelId{
    NSDictionary * params = nil;
    
    if (novelId.length) {
        params = @{@"novel_id":novelId};
    }
    
    NSArray * tmp = [SQLiteManager queryByParamsWithTableName:@"book" andClass:[self class] andParams:params];
    NSMutableArray * dataArray = [NSMutableArray new];
    
    for (BookDatabase * bookDataBase in tmp) {
        Book * book = [Book new];
        
        BookNovel * bookNovel = [BookNovel new];
        bookNovel.Id = bookDataBase.novel_id;
        bookNovel.name = bookDataBase.novel_name;
        bookNovel.cover = bookDataBase.novel_cover;
        bookNovel.intro = bookDataBase.novel_intro;
        
        BookAuthor * bookAuthor = [BookAuthor new];
        bookAuthor.name = bookDataBase.author_name;
        
        BookCategory * bookCategory = [BookCategory new];
        bookCategory.Id = bookDataBase.category_id;
        bookCategory.name = bookDataBase.category_name;
        
        BookLastUpdate * bookLastUpdate= [BookLastUpdate new];
        bookLastUpdate.time = bookDataBase.lastupdate_chapter_time;
        bookLastUpdate.name = bookDataBase.lastupdate_chapter_name;
        
        BookSource * bookSource = [BookSource new];
        bookSource.siteid = bookDataBase.source_siteid;
        
        book.currIndexPath = [NSIndexPath indexPathForRow:bookDataBase.read_chapter_row inSection:bookDataBase.read_chapter_section];
        book.novel = bookNovel;
        book.author = bookAuthor;
        book.category = bookCategory;
        book.last = bookLastUpdate;
        book.source = bookSource;
        
        [book refreshBasicData];
        
        [dataArray addObject:book];
    }
    
    return dataArray;
}

+ (BOOL)removeBookDataFromDatabaseWithNovelId:(NSString *)novelId{
    NSDictionary * params = nil;
    if (novelId.length) {
        params = @{@"novel_id":novelId};
    }
    return [SQLiteManager deleteWithTableName:@"book" andClass:nil andParams:params];
}

@end
