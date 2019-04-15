//
//  AKReaderManager.m
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKReaderManager.h"
#import "SDWebImageManager.h"
#import "AKSignalManager+ReaderModule.h"

#import "AFNetworking.h"

@interface AKReaderManager()

@property (nonatomic,strong) dispatch_queue_t   myQueue ;


@end

@implementation AKReaderManager

@synthesize bookShelf = _bookShelf;

SINGLETON_IMPL(AKReaderManager)

-(id)init
{
    self = [super init];
    if(self){
        _books =    [[NSMutableDictionary alloc] init];
        _bookShelf = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - prop
- (dispatch_queue_t)myQueue
{
    if (!_myQueue) {
        _myQueue = dispatch_queue_create("mySyncQueue", DISPATCH_QUEUE_CONCURRENT) ;
    }
    return _myQueue ;
}

-(void)loadBookShelf
{
    
    NSArray* data = [Book fetcher].FETCH_MODELS();
  
    NSInteger count = [data count];
    [_bookShelf removeAllObjects];
    for(NSInteger i=0; i< count; i++){
        Book* book = [data objectAtIndex:i];
        book = [self addBook:book];
        [_bookShelf addObject:book];
    }
    AK_SIGNAL_MANAGER.onBookShelfChange.fire(_bookShelf);
}

-(Book*)addBook:(Book*)book
{
    Book* tempBook = [_books objectForKey:book.novel.Id];
    
    if(tempBook){
      //  [tempBook fillData:book];
    }else{
        tempBook = book;
        [_books setObject:book forKey:book.novel.Id];
    }
    return tempBook;
}

-(void)setBookShelf:(NSMutableArray *)bookShelf
{
    NSAssert(FALSE, @"不支持外部直接更新整个数组");
    
}

-(void)bookmark:(Book*)book
{
    book.isBookmark = !book.isBookmark;
    [_bookShelf addObject:book];
    [book saveOrReplce:YES];
 //   [[AKDBManager sharedInstance] book_insertOrReplace:book];
    AK_SIGNAL_MANAGER.onBookShelfChange.fire(_bookShelf);
}
-(void)unBookmark:(Book*)book
{
    book.isBookmark = !book.isBookmark;
    [_bookShelf removeObject:book];
    [book deleteRecord];
//    [[AKDBManager sharedInstance] book_deleteByID:book.novel.Id];
    AK_SIGNAL_MANAGER.onBookShelfChange.fire(_bookShelf);
}


- (NSMutableArray *)bookShelf
{
    if (!_bookShelf) {
        _bookShelf = [@[] mutableCopy] ;
    }
    return _bookShelf ;
    
}

-(void)requestBookChapters:(Book *)book
{
    [AK_REQUEST_MANAGER reader_requestBookDetailWithNovelID:book.novel.Id withSiteID:book.source.siteid success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSData* jsonData = request.responseData;
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSInteger errorCode =[response[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:response[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
        
        [book.bookChapters removeAllObjects];
        
        NSArray * dataArray = response[@"data"];
        
        for (NSDictionary * dict in dataArray) {
            [book.bookChapters addObject:[BookChapter bookChapterWithDict:dict]];
        }
        
        book.onChaptersChange.fire(book.bookChapters);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}
//
//-(void)moduleInitConfigure
//{
//  
//    //设置图片内存缓存为20M
//    [[SDImageCache sharedImageCache] setMaxCacheSize:1024*1024*20];
//    
//    //开启网络监测
//    
//    //初始化数据
//}
//


-(AKDownloadGroupModel*)startDownloadBook:(Book *)book atIndex:(NSInteger)index
{
    AKDownloadGroupModel* downloadGroup = [[AKDownloadManager sharedInstance] getDownloadGroup:book.novel.name];
    if(downloadGroup == nil){
        downloadGroup = [[AKDownloadManager sharedInstance] createTaskGroup:book.novel.name withBreakpointResume:NO];
    }
    NSInteger count = book.bookChapters.count;
    for(NSInteger i=0; i<count; i++){
        BookChapter* chapter = [book.bookChapters objectAtIndex:i];
        
        AKDownloadModel* model = [[AKDownloadManager sharedInstance] createTask:book.novel.name withTaskName:chapter.name withIcon:book.novel.cover withDesc:chapter.name withDownloadUrl:chapter.url withFilename:@""];
        [downloadGroup addTaskModel:model];
    }
    
    
    [[AKDownloadManager sharedInstance] startGroup:downloadGroup atIndex:index];
    
    return downloadGroup;
    
}





@end
