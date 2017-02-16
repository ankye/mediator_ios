//
//  AKBookDetailHandler.m
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookDetailHandler.h"

#import "AKBaseTableViewDelegate.h"
#import "AKBaseTableView.h"
#import "Book.h"
#import "BookDetailBasicCell.h"
#import "BookDetailChapterCell.h"
#import "BookDetailIntroduceCell.h"
#import "BookChapter.h"

#import "NSString+Category.h"
#import "SGDownloadManager.h"
#import "AKDownloadManager.h"

@interface AKBookDetailHandler () <AKBaseTableViewDelegate>

@property (nonatomic,assign) NSInteger          lastPage ;

@property(nonatomic,weak) UIButton * allCacheBtn;
@property (nonatomic,weak) AKDownloadGroupModel* downloadGroup;

/**
 *  是否继续缓存
 */
@property(nonatomic,assign)BOOL isContinueCache;
/**
 *  当前下标
 */
@property (nonatomic, assign) NSInteger currentTmpIndex;

@end

@implementation AKBookDetailHandler

//@synthesize dataList = _dataList;


#pragma mark - life
- (void)dealloc
{
    if(_book){
        [_book.onChaptersChange removeObserver:self];
    }
   // _dataList = nil ;
    if(_downloadGroup){
        [_downloadGroup.onDownloadProgress removeObserver:self];
        [_downloadGroup.onDownloadCompleted removeObserver:self];
        _downloadGroup = nil;
    }
}



#pragma mark - public func
- (BOOL)hasDataSource
{
    if(_book == nil){
        return NO;
    }
    NSMutableArray* datalist = _book.bookChapters;
    
    BOOL dataNotNull = datalist != nil  ;
    BOOL dataHasCount = datalist.count ;
    return dataNotNull && dataHasCount ;
}

-(NSString*)getTitle
{
    return @"";
}



-(void)refresh
{
    
    if(_book && _book.bookChapters.count > 0){
        
    }else{
        
        [AKPopupManager showProgressHUDAtView:self.table];
    }
    
    [_book.onChaptersChange addObserver:self callback:^(typeof(self) self, NSMutableArray * _Nonnull mutableArray) {
        [self.table refreshData];
        
        [AKPopupManager hideProgressHUDAtView:self.table];
    }];
    
    [[AKReaderManager sharedInstance] requestBookChapters:_book];
    

}
- (void)loadNewData
{
    
    
    
    
    
    
}

- (void)loadMoreData
{
    
   
    
    // Content *lastContent = [self.dataList lastObject] ;
    
    
}





#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section<2) {
        return 1;
    }
    return _book.bookChapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * identifier=@"BookDetailBasicCell";
        BookDetailBasicCell * cell= (BookDetailBasicCell*)[self getCell:tableView withName:identifier];
        [cell.goReadBtn addTarget:self action:@selector(goReadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.allCacheBtn addTarget:self action:@selector(allCacheBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.joinShelfBtn addTarget:self action:@selector(joinShelfBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.book = self.book;
        self.allCacheBtn = cell.allCacheBtn;
    
        return cell;
    }else if(indexPath.section==1){
        static NSString * identifier=@"BookDetailIntroduceCell";
        BookDetailIntroduceCell * cell= (BookDetailIntroduceCell*)[self getCell:tableView withName:identifier];
        cell.bookIntroduceLabel.text = self.book.novel.intro;
        return cell;
    }else{
        static NSString * identifier = @"BookDetailChapterCell";
        BookDetailChapterCell * cell = (BookDetailChapterCell*)[self getCell:tableView withName:identifier];
        
        BookChapter * bookChapter = _book.bookChapters[indexPath.row];
        
        cell.indexLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        
        cell.chapterNameLabel.text = bookChapter.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section>1) {
      //  [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
    }else if(indexPath.section==0){
      //  [self goReadBtnClick:nil];
    }
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
    }else if(indexPath.section==1){
        return self.book.novel.introHeight+60;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - private
- (void)goReadBtnClick:(UIButton *)btn{
   // [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:0];
    
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSectionClick:withRow:withClickChannel:withContent:)]){
        [self.handlerDelegate didSectionClick:0 withRow:0 withClickChannel:0 withContent:nil];
    }
    
}
- (void)joinShelfBtnClick:(UIButton *)btn{
 //   [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:1];
 //   [self reloadData];
    
    if (self.book.isBookmark) {//取消收藏
       // [BookDatabase removeBookDataFromDatabaseWithNovelId:self.book.novel.Id];
    //    [[AKDBManager sharedInstance] book_deleteByID:self.book.novel.Id];
        [[AKReaderManager sharedInstance] unBookmark:self.book];
    }else{//加入收藏
//        [BookDatabase saveBookToDataBaseWithIndexPath:self.book.currIndexPath andBook:self.book];
        
    //    [[AKDBManager sharedInstance] book_insertOrReplace:self.book];
        [[AKReaderManager sharedInstance] bookmark:self.book];
    }
    
   
    
    
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSectionClick:withRow:withClickChannel:withContent:)]){
        [self.handlerDelegate didSectionClick:0 withRow:0 withClickChannel:1 withContent:nil];
    }
    [self.table refreshData];
    
}
- (void)allCacheBtnClick:(UIButton *)btn{
  //  [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:2];
    
    if (self.book.bookCacheStatus==BOOK_CACHE_STATUS_ING) {//暂停缓存
        self.isContinueCache = false;
        self.book.bookCacheStatus = BOOK_CACHE_STATUS_NONE;
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        AKDownloadGroupModel* group = [[AKDownloadManager sharedInstance] getDownloadGroup:_book.novel.name];
        if(group){
            [[AKDownloadManager sharedInstance] pauseGroup:group];
        }
    }else{//开始缓存
        
        self.book.bookCacheStatus = BOOK_CACHE_STATUS_ING;
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        self.isContinueCache = true;
     //   [self startTmp];
        [self startDownload];
    }

    
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSectionClick:withRow:withClickChannel:withContent:)]){
        [self.handlerDelegate didSectionClick:0 withRow:0 withClickChannel:2 withContent:nil];
    }
}

#pragma mark - setter
- (void)setBook:(Book *)book{
    _book = book;
    _downloadGroup = [[AKDownloadManager sharedInstance] getDownloadGroup:_book.novel.name];
    [self updateDownloadState];
    [self.table refreshData];
}

-(void)updateDownloadState
{
    if(_downloadGroup){
        if(_downloadGroup.groupState == HSDownloadStateCompleted){
            _book.bookCacheStatus = BOOK_CACHE_STATUS_ALL_END;
        }else if(_downloadGroup.groupState == HSDownloadStateRunning ){
            _book.bookCacheStatus = BOOK_CACHE_STATUS_ING;
        }else{
            _book.bookCacheStatus = BOOK_CACHE_STATUS_NONE;
        }
        [_downloadGroup.onDownloadProgress addObserver:self callback:^(id  _Nonnull self, NSDictionary * _Nonnull dictionary) {
            [self downloadProgress:dictionary[@"groupName"] withUrl:dictionary[@"url"] withProgress:[dictionary[@"progress"] floatValue] withTotalRead:[dictionary[@"total"] floatValue ] withTotalExpected:[dictionary[@"expected"] floatValue]];
        }];
        [_downloadGroup.onDownloadCompleted addObserver:self callback:^(id  _Nonnull self, NSDictionary * _Nonnull dictionary) {
            [self downloadComplete:(HSDownloadState)[dictionary[@"state"] integerValue] withGroupName:dictionary[@"groupName"] downLoadUrlString:dictionary[@"url"]];
        }];
    }
}

-(void)downloadProgress:(NSString*)groupName withUrl:(NSString*)url withProgress:(CGFloat)progress withTotalRead:(CGFloat)totalRead withTotalExpected:(CGFloat)expected
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* cacheTitle = [NSString stringWithFormat:@"%ld/%ld",(long)_downloadGroup.currentTaskIndex,(long)[_downloadGroup.tasks count]];
        [self.allCacheBtn setTitle:cacheTitle forState:UIControlStateNormal];

    });
}

-(void)downloadComplete:(HSDownloadState)downloadState withGroupName:(NSString*)groupName downLoadUrlString:(NSString *)downLoadUrlString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.allCacheBtn setTitle:@"下载完成" forState:UIControlStateNormal];

    });
}

-(void) startDownload
{
    if(_book.bookChapters.count>0){
        if(_downloadGroup == nil){
            _downloadGroup = [[AKDownloadManager sharedInstance] createTaskGroup:_book.novel.name withBreakpointResume:NO];
        }
        NSInteger count = _book.bookChapters.count;
        for(NSInteger i=0; i<count; i++){
            BookChapter* chapter = [_book.bookChapters objectAtIndex:i];
            
            AKDownloadModel* model = [[AKDownloadManager sharedInstance] createTask:_book.novel.name withTaskName:chapter.name withIcon:_book.novel.cover withDesc:chapter.name withDownloadUrl:chapter.url withFilename:@""];
            [_downloadGroup addTaskModel:model];
        }
     

        [[AKDownloadManager sharedInstance] startGroup:_downloadGroup atIndex:0];
        
        [self updateDownloadState];
        [self.table refreshData];
    }
}
//#pragma mark - private
//- (void)startTmp{
//    if (!self.isContinueCache) {
//        return;
//    }
//    
//    if (self.dataList.count==self.currentTmpIndex+1) {
//        
//        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }else{
//        
//        __block typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            for (; weakSelf.currentTmpIndex<weakSelf.dataList.count; weakSelf.currentTmpIndex++) {
//                
//                BookChapter * chapter = weakSelf.dataList[weakSelf.currentTmpIndex];
//                if ([chapter.url hasPrefix:@"http"] && !chapter.isTmp) {
////                    weakSelf.requestUtil.isShowProgressHud = false;
////                    [weakSelf.requestUtil asyncThirdLibWithUrl:chapter.url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
//                    
//                    /** 开启下载任务 监听下载进度、完成下载 */
//                   [[SGDownloadManager shareManager] downloadWithURL:AKURL(chapter.url) progress:^(NSInteger completeSize, NSInteger expectSize) {
//                       NSLog(@"%ld-%ld",(long)completeSize,(long)expectSize);
//                   } complete:^(NSDictionary *respose, NSError *error) {
//                       NSString * path = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[chapter.url md5]];
//                       
//                       if([respose[@"isFinished"] boolValue]){
//                           [[NSFileManager defaultManager] moveItemAtPath:respose[@"fileUrl"] toPath:path error:nil];
//                           
//                           BookChapter * bookChapter = self.dataList[self.currentTmpIndex];
//                           
//                           bookChapter.isTmp = YES;
//                           
//                           [self startTmp];
//                           
//                           
//                       }
//
//                   }];
//                    
////                    
////                    [[SGDownloadManager shareManager] downloadWithURL:AKURL(chapter.url) complete:^(NSDictionary *respose, NSError *error) {
////                        
////                         NSString * path = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[chapter.url md5]];
////                        
////                        if([respose[@"isFinished"] boolValue]){
////                            [[NSFileManager defaultManager] moveItemAtPath:respose[@"fileUrl"] toPath:path error:nil];
////                            
////                            BookChapter * bookChapter = self.dataList[self.currentTmpIndex];
////                            
////                            bookChapter.isTmp = YES;
////                            
////                            [self startTmp];
////
////                            
////                        }
////                        
////                    }];
////                   
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString * title = [NSString stringWithFormat:@"%ld / %ld",weakSelf.currentTmpIndex,weakSelf.dataList.count];
//                        [weakSelf.allCacheBtn setTitle:title forState:UIControlStateNormal];
//                    });
//                    return;
//                }
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            });
//        });
//    }
//}

//
//#pragma mark - private
//- (void)asyncGetCurrentDirIsTmp{
//    
//    __block typeof(self) weakSelf = self;
//    //    NSLog(@"-------->%@",[NSDate date]);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        BOOL cacheStatus = YES;
//        
//        for (BookChapter * bookChapter in weakSelf.dataList) {
//            
//            NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,weakSelf.book.novel.Id,[bookChapter.url md5]];
//            
//            bookChapter.isTmp = [NSFileManager isExistsFileWithFilePath:filePath];
//            
//            if (bookChapter.isTmp==false) {
//                cacheStatus = false;
//            }
//        }
//        
//        if (cacheStatus) {
//            weakSelf.book.bookCacheStatus = BOOK_CACHE_STATUS_ALL_END;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            });
//        }
//        
//        //        NSLog(@"-------->%@",[NSDate date]);
//    });
//}
//

#pragma mark - scrollView delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float offsetY = scrollView.contentOffset.y ;
    
    if (self.handlerDelegate != nil && [self.handlerDelegate respondsToSelector:@selector(tablelWillEndDragWithOffsetY:WithVelocity:)]) {
        [self.handlerDelegate tablelWillEndDragWithOffsetY:offsetY WithVelocity:velocity] ;
    }
    
    //nav 吸附性
    //    NSLog(@"velocity : %@",NSStringFromCGPoint(velocity)) ;
    if (velocity.y > 0.) {
        if (velocity.y > 1.8) return ; // 超速 .
        // 上推
        
    }
}
@end
