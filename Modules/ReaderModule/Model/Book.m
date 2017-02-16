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



-(void)fillData:(id<AKDataObjectProtocol>)object
{
    
}

-(void)resultSetToModel:(FMResultSet *)retSet
{
    BookNovel * bookNovel = [BookNovel new];
    bookNovel.Id = [retSet stringForColumn:@"novel_id"];
    bookNovel.name =[retSet stringForColumn:@"novel_name"];
    bookNovel.cover =[retSet stringForColumn:@"novel_cover"];
    bookNovel.intro = [retSet stringForColumn:@"novel_intro"];
    self.read_chapter_section = [retSet intForColumn:@"read_chapter_section"];
    self.read_chapter_row = [retSet intForColumn:@"read_chapter_row"];
    
    BookAuthor * bookAuthor = [BookAuthor new];
    bookAuthor.name =[retSet stringForColumn:@"author_name"];
    
    BookCategory * bookCategory = [BookCategory new];
    bookCategory.Id = [retSet stringForColumn:@"category_id"];
    bookCategory.name = [retSet stringForColumn:@"category_name"];
    
    BookLastUpdate * bookLastUpdate= [BookLastUpdate new];
    bookLastUpdate.time =[retSet stringForColumn:@"lastupdate_chapter_time"];
    bookLastUpdate.name = [retSet stringForColumn:@"lastupdate_chapter_name"];
    
    BookSource * bookSource = [BookSource new];
    bookSource.siteid = [retSet stringForColumn:@"source_siteid"];
    
    self.currIndexPath = [NSIndexPath indexPathForRow:[retSet intForColumn:@"read_chapter_row"] inSection:[retSet intForColumn:@"read_chapter_section"]];
    self.novel = bookNovel;
    self.author = bookAuthor;
    self.category = bookCategory;
    self.last = bookLastUpdate;
    self.source = bookSource;
    
    [self refreshBasicData];

}

-(NSArray*)modelDBProperties
{
    return @[@"novel_id",@"novel_cover",@"novel_name",@"novel_intro",@"author_name",@"lastupdate_chapter_time",@"lastupdate_chapter_name",@"category_id",@"category_name",@"read_chapter_section",@"source_siteid",@"has_sticky",@"ext_type",@"ext1",@"ext2",@"ext3",@"ext4",@"ext5"];
    
}
-(NSArray*)modelToDBRecord
{
    return @[ AKNoNilString(self.novel.Id),
             AKNoNilString(self.novel.cover),
             AKNoNilString(self.novel.name),
             AKNoNilString(self.novel.intro),
             AKNoNilString(self.author.name),
             AKNoNilString(self.last.time),
             AKNoNilString(self.last.name),
             AKNoNilString(self.category.Id),
             AKNoNilString(self.category.name),
             AKNoNilNumber(@(self.currIndexPath.section)),
             AKNoNilNumber(@(self.currIndexPath.row)),
             AKNoNilString(self.source.siteid),
             AKNoNilNumber(@(self.hasSticky)),
             AKNoNilNumber(@(self.extType)),
              @"",
              @"",
              @"",
              @"",
              @"",
             ];
}


@end


