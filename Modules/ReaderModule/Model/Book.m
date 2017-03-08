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

-(id)init
{
    self = [super init];
    if(self){
        _bookChapters = [[NSMutableArray alloc] init];
        _onChaptersChange =(UBSignal< MutableArraySignal > *) [[UBSignal alloc] initWithProtocol:@protocol(MutableArraySignal)];
        
    }
    return self;
}

-(void)dealloc
{
    [_onChaptersChange removeAllObservers];
    _onChaptersChange = nil;
}

- (void)refreshBasicData{
    
    if (self.novel.intro.length) {
        self.novel.introHeight = [self.novel.intro heightWithFontSize:13 andWidth:(SCREEN_WIDTH-20)];
    }
    
    if (self.last.time.length) {
        self.last.timeName = [NSDate getCustomTimeByCurrentTimeStrWithTimeInterval:[self.last.time integerValue]];
    }
    
    if (self.novel.cover.length && ![self.novel.cover hasPrefix:@"http"]) {
        self.novel.cover = [NSString stringWithFormat:@"%@%@",READER_SERVER,self.novel.cover];
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
    Book* temp = (Book*)object;
    
    if(temp.isLoadLocal){
        self.read_chapter_section = temp.read_chapter_section;
        self.read_chapter_row = temp.read_chapter_row;
        self.download_chapter_row = temp.download_chapter_row;
        self.download_chapter_section = temp.download_chapter_section;
        
        self.hasSticky = temp.hasSticky;
        self.isBookmark = temp.isBookmark;
        self.bookCacheStatus = temp.bookCacheStatus;
        self.extType = temp.extType;
        self.source.siteid = temp.source.siteid;
        
        self.novel.Id = temp.novel.Id;
        self.novel.name = temp.novel.name;
        self.novel.cover =temp.novel.cover;
        self.novel.intro = temp.novel.intro;
    
        self.author.name =temp.author.name;
    
        self.category.Id = temp.category.Id;
        self.category.name = temp.category.name;
    
        self.last.time = temp.last.time;
        self.last.name = temp.last.name;
        
    }else{
        
        [self.author fillData:temp.author];
        [self.category fillData:temp.category];
        [self.source fillData:temp.source];
        [self.novel fillData:temp.novel];
        [self.last fillData:temp.last];
        [self.url fillData:temp.url];
    }
    
    [self refreshBasicData];

}

-(void)resultSetToModel:(FMResultSet *)retSet
{
    BookNovel * bookNovel = [BookNovel new];
    bookNovel.Id = [retSet stringForColumn:@"novel_id"];
    bookNovel.name =[retSet stringForColumn:@"novel_name"];
    bookNovel.cover =[retSet stringForColumn:@"novel_cover"];
    bookNovel.intro = [retSet stringForColumn:@"novel_intro"];
    self.isLoadLocal = YES;
    self.read_chapter_section = [retSet intForColumn:@"read_chapter_section"];
    self.read_chapter_row = [retSet intForColumn:@"read_chapter_row"];
    
    self.download_chapter_section = [retSet intForColumn:@"download_chapter_section"];
    self.download_chapter_row = [retSet intForColumn:@"download_chapter_row"];
    
    self.isBookmark = [retSet boolForColumn:@"bookmark"];
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
    
    
    self.novel = bookNovel;
    self.author = bookAuthor;
    self.category = bookCategory;
    self.last = bookLastUpdate;
    self.source = bookSource;
    
    [self refreshBasicData];

}

-(NSArray*)modelDBProperties
{
    return @[@"novel_id",@"novel_cover",@"novel_name",@"novel_intro",@"author_name",@"lastupdate_chapter_time",@"lastupdate_chapter_name",@"category_id",@"category_name",@"read_chapter_section",@"read_chapter_row",@"download_chapter_section",@"download_chapter_row",@"source_siteid",@"bookmark",@"has_sticky",@"ext_type",@"ext1",@"ext2",@"ext3",@"ext4",@"ext5"];
    
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
             AKNoNilNumber(@(self.read_chapter_section)),
             AKNoNilNumber(@(self.read_chapter_row)),
              AKNoNilNumber(@(self.download_chapter_section)),
              AKNoNilNumber(@(self.download_chapter_row)),
             AKNoNilString(self.source.siteid),
             AKNoNilNumber(@(self.isBookmark)),
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


