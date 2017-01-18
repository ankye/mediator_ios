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
#import "BookDatabase.h"
#import "NSString+Category.h"
#import "NSFileManager+FileCategory.h"

@interface AKBookDetailHandler () <AKBaseTableViewDelegate>

@property (nonatomic,strong) NSMutableArray     *dataList ;
@property (nonatomic,assign) NSInteger          lastPage ;

@property(nonatomic,weak) UIButton * allCacheBtn;

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

@synthesize dataList = _dataList;


#pragma mark - life
- (void)dealloc
{
    _dataList = nil ;
    
}



#pragma mark - public func
- (BOOL)hasDataSource
{
    BOOL dataNotNull = _dataList != nil  ;
    BOOL dataHasCount = _dataList.count ;
    return dataNotNull && dataHasCount ;
}

-(NSString*)getTitle
{
    return @"";
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [@[] mutableCopy] ;
    }
    return _dataList ;
    
    __block NSMutableArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _dataList ;
    }) ;
    return list ;
}

- (void)setDataList:(NSMutableArray *)dataList
{
    dispatch_barrier_async(self.myQueue, ^{
        _dataList = dataList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData] ;
        }) ;
    }) ;
}



- (void)loadNewData
{
    
    NSMutableArray*tmpList_data = [@[] mutableCopy] ;
    
    [AK_REQUEST_MANAGER reader_requestBookDetailWithNovelID:self.book.novel.Id withSiteID:self.book.source.siteid success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSData* jsonData = request.responseData;
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSInteger errorCode =[response[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:response[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }

        
        
        NSArray * dataArray = response[@"data"];
        
        for (NSDictionary * dict in dataArray) {
            [self.dataList addObject:[BookChapter bookChapterWithDict:dict]];
        }

        [self.table reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
    
    
    
    
}

- (void)loadMoreData
{
    
    if (!self.dataList.count) {
        return ;
    }
    
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
    return self.dataList.count;
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
        
        BookChapter * bookChapter = self.dataList[indexPath.row];
        
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
    
    if (self.book.isCaseBook) {//取消收藏
        [BookDatabase removeBookDataFromDatabaseWithNovelId:self.book.novel.Id];
    }else{//加入收藏
        [BookDatabase saveBookToDataBaseWithIndexPath:self.book.currIndexPath andBook:self.book];
    }
    self.book.isCaseBook = !self.book.isCaseBook;
    
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSectionClick:withRow:withClickChannel:withContent:)]){
        [self.handlerDelegate didSectionClick:0 withRow:0 withClickChannel:1 withContent:nil];
    }
    
}
- (void)allCacheBtnClick:(UIButton *)btn{
  //  [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:2];
    
    if (self.book.bookCacheStatus==BOOK_CACHE_STATUS_ING) {//暂停缓存
        self.isContinueCache = false;
        self.book.bookCacheStatus = BOOK_CACHE_STATUS_NONE;
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{//开始缓存
        
        self.book.bookCacheStatus = BOOK_CACHE_STATUS_ING;
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        self.isContinueCache = true;
        [self startTmp];
    }

    
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSectionClick:withRow:withClickChannel:withContent:)]){
        [self.handlerDelegate didSectionClick:0 withRow:0 withClickChannel:2 withContent:nil];
    }
}

#pragma mark - setter
- (void)setBook:(Book *)book{
    _book = book;
  //  [self reloadData];
}

#pragma mark - private
- (void)startTmp{
    if (!self.isContinueCache) {
        return;
    }
    
    if (self.dataList.count==self.currentTmpIndex+1) {
        
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        __block typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (; weakSelf.currentTmpIndex<weakSelf.dataList.count; weakSelf.currentTmpIndex++) {
                
                BookChapter * chapter = weakSelf.dataList[weakSelf.currentTmpIndex];
                if ([chapter.url hasPrefix:@"http"] && !chapter.isTmp) {
//                    weakSelf.requestUtil.isShowProgressHud = false;
//                    [weakSelf.requestUtil asyncThirdLibWithUrl:chapter.url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
                    [AK_REQUEST_MANAGER reader_requestBookChapterWithURL:chapter.url success:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        NSData* data = request.responseData;
                        
                        NSString * path = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[chapter.url md5]];
                        [NSFileManager writeToFile:path withData:data];
                        
                        BookChapter * bookChapter = self.dataList[self.currentTmpIndex];
                        
                        bookChapter.isTmp = YES;
                        
                        [self startTmp];

                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString * title = [NSString stringWithFormat:@"%ld / %ld",weakSelf.currentTmpIndex,weakSelf.dataList.count];
                        [weakSelf.allCacheBtn setTitle:title forState:UIControlStateNormal];
                    });
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
}


#pragma mark - private
- (void)asyncGetCurrentDirIsTmp{
    
    __block typeof(self) weakSelf = self;
    //    NSLog(@"-------->%@",[NSDate date]);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL cacheStatus = YES;
        
        for (BookChapter * bookChapter in weakSelf.dataList) {
            
            NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,weakSelf.book.novel.Id,[bookChapter.url md5]];
            
            bookChapter.isTmp = [NSFileManager isExistsFileWithFilePath:filePath];
            
            if (bookChapter.isTmp==false) {
                cacheStatus = false;
            }
        }
        
        if (cacheStatus) {
            weakSelf.book.bookCacheStatus = BOOK_CACHE_STATUS_ALL_END;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        
        //        NSLog(@"-------->%@",[NSDate date]);
    });
}


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
