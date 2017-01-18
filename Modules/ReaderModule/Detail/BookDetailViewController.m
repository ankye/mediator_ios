//
//  BookDetailViewController.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookReadViewController.h"
#import "BookDetailMainView.h"
#import "BookDatabase.h"

#import "NSFileManager+FileCategory.h"

@interface BookDetailViewController ()<BookDetailMainViewDelegate>

@property (weak, nonatomic) IBOutlet BookDetailMainView *mainView;
/**
 *  目录的数据
 */
@property(nonatomic,strong)NSMutableArray * dirDataArray;
/**
 *  当前下标
 */
@property (nonatomic, assign) NSInteger currentTmpIndex;
/**
 *  是否继续缓存
 */
@property(nonatomic,assign)BOOL isContinueCache;
/**
 *  是否在底部
 */
@property(nonatomic,assign)BOOL isBottom;

@end

@implementation BookDetailViewController

- (instancetype)init
{
    NSString * identifier = NSStringFromClass([self class]);
    UIStoryboard * sb = [UIStoryboard storyboardWithName:identifier bundle:nil];
    return  [sb instantiateViewControllerWithIdentifier:identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadMainView];
    [self loadNavigationBar];
    [self downloadData];
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];

}

- (void)loadMainView{
    
    Book *book = [[BookDatabase bookDataListFromDatabaseWithNovelId:self.book.novel.Id] firstObject];
    if (book) {
        self.book.isCaseBook = YES;
        self.book.currIndexPath = book.currIndexPath;
    }
    
    self.mainView.book = self.book;
    self.mainView.mainViewDelegate = self;
    
}

- (void)loadNavigationBar{
    self.navigationItem.title = self.book.novel.name;
    
    UIButton * rightSortBtn = [RootNavButton buttonWithTitle:@"底部"];
    [rightSortBtn addTarget:self action:@selector(rightSortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithCustomView:rightSortBtn];
    self.navigationItem.rightBarButtonItem = rbbi;
}


#pragma mark - click private
- (void)rightSortBtnClick:(UIButton *)rightBtn{
    
    self.isBottom = !self.isBottom;
    
    if (self.isBottom) {
        [rightBtn setTitle:@"顶部" forState:UIControlStateNormal];
        [self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height-self.mainView.height) animated:YES];
    }else{
        [rightBtn setTitle:@"底部" forState:UIControlStateNormal];
        [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - BookDetailMainViewDelegate
- (void)basicFuncBtnClickWithMainView:(BookDetailMainView *)mainView andIndex:(NSInteger)index{
    if (index ==0) {
        BookReadViewController * con = [BookReadViewController new];
        con.book = self.book;
        con.dataArray = self.dirDataArray;
        [self.navigationController pushViewController:con animated:YES];
    }else if (index == 1){
        if (self.book.isCaseBook) {//取消收藏
            [BookDatabase removeBookDataFromDatabaseWithNovelId:self.book.novel.Id];
        }else{//加入收藏
            [BookDatabase saveBookToDataBaseWithIndexPath:self.book.currIndexPath andBook:self.book];
        }
        self.book.isCaseBook = !self.book.isCaseBook;
    }else if (index ==2 ){//共三个状态
        if (self.book.bookCacheStatus==BOOK_CACHE_STATUS_ING) {//暂停缓存
            self.isContinueCache = false;
            self.book.bookCacheStatus = BOOK_CACHE_STATUS_NONE;
            [self.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{//开始缓存
            
            self.book.bookCacheStatus = BOOK_CACHE_STATUS_ING;
            [self.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            self.isContinueCache = true;
            [self startTmp];
        }
    }
}

- (void)itemSelectedWithMainView:(BookDetailMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    BookReadViewController * con = [BookReadViewController new];
    con.book = self.book;
    con.readIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    con.dataArray = self.dirDataArray;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - private
- (void)startTmp{
    if (!self.isContinueCache) {
        return;
    }
    
    if (self.dirDataArray.count==self.currentTmpIndex+1) {
        
        [self.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        __block typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (; weakSelf.currentTmpIndex<weakSelf.dirDataArray.count; weakSelf.currentTmpIndex++) {
                
                BookChapter * chapter = weakSelf.dirDataArray[weakSelf.currentTmpIndex];
                if ([chapter.url hasPrefix:@"http"] && !chapter.isTmp) {
                    weakSelf.requestUtil.isShowProgressHud = false;
                    [weakSelf.requestUtil asyncThirdLibWithUrl:chapter.url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString * title = [NSString stringWithFormat:@"%ld / %ld",weakSelf.currentTmpIndex,weakSelf.dirDataArray.count];
                        [weakSelf.mainView.allCacheBtn setTitle:title forState:UIControlStateNormal];
                    });
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
}

#pragma mark - 下载数据
- (void)downloadData{
    NSString * url = [NSString stringWithFormat:URL_GET_NOVEL_DIR,self.book.novel.Id,self.book.source.siteid];
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodPost andTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    if(statusCode==200 && !error){
        if ([urlString isEqualURLWithURL:URL_GET_NOVEL_DIR]) {
            
            NSDictionary * dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSInteger errorCode =[dictData[@"status"] integerValue];
            if(errorCode!=1){
                [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:dictData[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                return;
            }
            
            
            NSArray * dataArray = dictData[@"data"];
            
            for (NSDictionary * dict in dataArray) {
                [self.dirDataArray addObject:[BookChapter bookChapterWithDict:dict]];
            }
            
            self.mainView.dataArray = self.dirDataArray;
            
            [self asyncGetCurrentDirIsTmp];
        }else{
            
            NSString * path = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[urlString md5]];
            [NSFileManager writeToFile:path withData:data];
            
            BookChapter * bookChapter = self.dirDataArray[self.currentTmpIndex];
            
            bookChapter.isTmp = YES;
            
            [self startTmp];
        }
    }else{
        
    }
}

#pragma mark - private
- (void)asyncGetCurrentDirIsTmp{
    
    __block typeof(self) weakSelf = self;
//    NSLog(@"-------->%@",[NSDate date]);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL cacheStatus = YES;
        
        for (BookChapter * bookChapter in weakSelf.dirDataArray) {
            
            NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,weakSelf.book.novel.Id,[bookChapter.url md5]];
            
            bookChapter.isTmp = [NSFileManager isExistsFileWithFilePath:filePath];
            
            if (bookChapter.isTmp==false) {
                cacheStatus = false;
            }
        }
        
        if (cacheStatus) {
            weakSelf.book.bookCacheStatus = BOOK_CACHE_STATUS_ALL_END;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        
//        NSLog(@"-------->%@",[NSDate date]);
    });
}

#pragma mark - getter
- (NSMutableArray *)dirDataArray{
    if (!_dirDataArray) {
        _dirDataArray = [NSMutableArray new];
    }
    return _dirDataArray;
}

#pragma mark - 系统协议
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.hidesBarsOnSwipe = NO;
    [self.mainView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
