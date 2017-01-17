//
//  BookReadViewController.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadViewController.h"
#import "BookReadSelectChapterViewController.h"
#import "BookReadMainView.h"
#import "BookReadDirMaskView.h"
#import "BookReadSettingFooterView.h"
#import "BookChapter.h"

#import "BookDatabase.h"

#import "NSString+Category.h"
#import "NSFileManager+FileCategory.h"

@interface BookReadViewController ()<BookReadMainViewDelegate,BookReadSelectChapterViewControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,weak) BookReadMainView * mainView;

@property(nonatomic,weak) BookReadDirMaskView * dirMaskView;

@property(nonatomic,weak) BookReadSettingFooterView * settingFooterView;

@property(nonatomic,strong)NSMutableArray * tmpGetDataDataArray;
//现在需要获取小说数据下标
@property (nonatomic, assign) NSInteger currDataIndex;
//现在需要获取小说数据对象
@property(nonatomic,strong)BookChapter * currBookChapter;

@end

@implementation BookReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
    
}

- (void)loadMainView{
    
    if (!self.readIndexPath) {
        
        Book * book = [[BookDatabase bookDataListFromDatabaseWithNovelId:self.book.novel.Id] firstObject];
        
        self.book.isCaseBook = book!=nil;
        
        self.readIndexPath = book.currIndexPath;
    }
    
    
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(WIDTH, HEIGHT);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    BookReadMainView * mainView = [[BookReadMainView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:layout];
    mainView.mainViewDelegate = self;
    [self.view addSubview:mainView];
    self.mainView = mainView;
    
    //创建遮罩view
    BookReadDirMaskView * dirMaskView = [BookReadDirMaskView viewFromNib];
    dirMaskView.frame = self.view.bounds;
    dirMaskView.novelNameLabel.text = self.book.novel.name;
    [dirMaskView.reGetDataBtn addTarget:self action:@selector(reGetDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    dirMaskView.hidden = YES;
    self.dirMaskView = dirMaskView;
    
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dirMaskViewClick)];
    
    [self.dirMaskView addGestureRecognizer:tgr];
    
    [self.view addSubview:dirMaskView];
    
    //底部目录、设置
    BookReadSettingFooterView * settingFooterView = [BookReadSettingFooterView viewFromNib];
    settingFooterView.frame=CGRectMake(0, HEIGHT, WIDTH, 49);
    [settingFooterView.dirBtn addTarget:self action:@selector(selectChapterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [settingFooterView.reloadBtn addTarget:self action:@selector(reloadCurrChapter) forControlEvents:UIControlEventTouchUpInside];
    
    self.settingFooterView = settingFooterView;
    [self.view addSubview:settingFooterView];
    
    
    if (self.dataArray.count==0) {
        [self downloadData];
    }else{
        self.mainView.dataArray = self.dataArray;
        
        BookChapter * bookChapter = self.dataArray[self.readIndexPath.section];
        
        if (bookChapter) {
            
            if ([self isExitNovelByNovelTextUrl:bookChapter.url]) {
                [self getDataByNovelTextUrl:bookChapter.url];
            }
        }
        
        self.readIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.readIndexPath.section];
        
        [self.mainView scrollToItemAtIndexPath:self.readIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)loadNavigationBar{
    self.navigationItem.title = self.book.novel.name;
    
    UIBarButtonItem * lbbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreViewController)];
    self.navigationItem.leftBarButtonItem = lbbi;
}

- (void)backToPreViewController{
    
    if (!self.book.isCaseBook) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"是否加入我的藏书阁？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的",@"不了", nil];
        
        [av show];
    }else{
        NSIndexPath * indexPath = [[self.mainView indexPathsForVisibleItems] firstObject];
        
        [BookDatabase saveBookToDataBaseWithIndexPath:indexPath andBook:self.book];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - click    private
- (void)dirMaskViewClick{
    [self hiddenOrShowAllBarAndFooterView];
}

- (void)reGetDataBtnClick:(UIButton *)btn{
    [self downloadData];
}

- (void)reloadCurrChapter{
    NSArray<NSIndexPath *> *indexpaths = [self.mainView indexPathsForVisibleItems];
    
    if (indexpaths.count) {
        
        BookChapter *bookChapter = self.dataArray[[indexpaths firstObject].section];
        
        NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[bookChapter.url md5]];
        [NSFileManager removeFilePath:filePath];
        
        bookChapter.textDataArray = nil;
        
        [self requestDataWithMainView:self.mainView andCurrIndex:[indexpaths firstObject].section];
    }
}

- (void)selectChapterBtnClick{
    [self hiddenOrShowAllBarAndFooterView];
    //跳转到目录
    BookReadSelectChapterViewController * con = [BookReadSelectChapterViewController new];
    con.delegate = self;
    con.bookNovelId = self.book.novel.Id;
    con.dataArray = self.dataArray;
    NSArray<NSIndexPath *> *indexpaths = [self.mainView indexPathsForVisibleItems];
    
    if (indexpaths.count) {
        con.currentIndex = [indexpaths firstObject].section;
    }
    
    [self.navigationController pushViewController:con animated:YES];
}

- (void)hiddenOrShowAllBarAndFooterView{
    BOOL isHidden = ![UIApplication sharedApplication].statusBarHidden;
    
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
    
    __block typeof(self) weakSelf = self;
    
    if (isHidden) {
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            weakSelf.settingFooterView.y = HEIGHT;
        }];
    }else{
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            weakSelf.settingFooterView.y = HEIGHT-49;
        }];
    }
}

#pragma mark - BookReadMainViewDelegate
- (void)itemSelectedWithMainView:(BookReadMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    [self hiddenOrShowAllBarAndFooterView];
}
//缓存数据总入口
- (void)requestDataWithMainView:(BookReadMainView *)mainView  andCurrIndex:(NSInteger)currIndex{
    self.currDataIndex = currIndex;
    self.currBookChapter = self.dataArray[currIndex];
    
    NSArray * preloadArr = [self getPreloadDataArrayByCurrentIndex:currIndex];
    
    for (NSNumber * num in preloadArr) {
        BookChapter * bookChapter = self.dataArray[[num integerValue]];
        [self.tmpGetDataDataArray addObject:bookChapter];
        
        //加载数据
        [self getDataByNovelTextUrl:bookChapter.url];
    }
}

#pragma mark - BookReadSelectChapterViewControllerDelegate
- (void)selectedNewChapterWithCon:(BookReadSelectChapterViewController *)con andIndex:(NSInteger)index{
    [con.navigationController popViewControllerAnimated:YES];
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSIndexPath * indexPath = [[self.mainView indexPathsForVisibleItems] firstObject];
        
        [BookDatabase saveBookToDataBaseWithIndexPath:indexPath andBook:self.book];
        self.book.isCaseBook = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
                [self.dataArray addObject:[BookChapter bookChapterWithDict:dict]];
            }
            
            if (self.dataArray.count<=self.readIndexPath.section) {
                self.readIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.dataArray.count-1];
            }
            
            self.dirMaskView.hidden = YES;
            
            self.mainView.dataArray = self.dataArray;
            
            [self.mainView scrollToItemAtIndexPath:self.readIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
            
        }else{
            
            NSString * path = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[urlString md5]];
            [NSFileManager writeToFile:path withData:data];
            
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUnicodeStringEncoding];
            
            [self parsingBookTextToArrayWithStr:str andUrlString:urlString];
        }
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([urlString isEqualURLWithURL:URL_GET_NOVEL_DIR]) {
            self.dirMaskView.hidden = NO;
        }else{
            [self.mainView setGetNullDataForCellWithUrl:urlString];
        }
    }
}

#pragma mark - private
- (void)parsingBookTextToArrayWithStr:(NSString *)str andUrlString:(NSString *)urlString{
    
    BookChapter * bookChapter = nil;
    
    for (BookChapter * bc in self.tmpGetDataDataArray) {
        if ([bc.url isEqualToString:urlString]) {
            bookChapter = bc;
            break;
        }
    }
    
    if (!bookChapter) {
        return;
    }
    
    if (bookChapter.textDataArray.count>1) {
        return;
    }else if(bookChapter.textDataArray.count==1){
        
        NSString * tmpText = [bookChapter.textDataArray firstObject];
        if (![tmpText isEqualToString:FINAL_EMPTY_VALUE_PROMPT_INFO]) {
            return;
        }
    }
    
    NSInteger dataIndex = [self.dataArray indexOfObject:bookChapter];
    
    if (self.currDataIndex == dataIndex) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    __block typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        bookChapter.textDataArray = [BookChapter parsingTextToTextArray:str];
        
        if (bookChapter.textDataArray.count==0) {
            [bookChapter.textDataArray addObject:FINAL_EMPTY_VALUE_PROMPT_INFO];
        }
        
        NSInteger index = [weakSelf.dataArray indexOfObject:bookChapter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (index == weakSelf.currDataIndex) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [weakSelf.mainView reloadData];
                [weakSelf.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        });
        
        [weakSelf.tmpGetDataDataArray removeObject:bookChapter];
        
    });
}

//获取数据，有则加载，无则请求
- (void)getDataByNovelTextUrl:(NSString *)novelTextUrl{
    if([self isExitNovelByNovelTextUrl:novelTextUrl]){
        self.dirMaskView.hidden = YES;
        
        NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[novelTextUrl md5]];
        NSString * text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:nil];
        
        if (![text isEqualToEmptyStr]) {
            [self parsingBookTextToArrayWithStr:text andUrlString:novelTextUrl];
        }else{
            self.requestUtil.isShowProgressHud = [self.currBookChapter.url isEqualToString:novelTextUrl];
            [self.requestUtil asyncThirdLibWithUrl:novelTextUrl andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
        }
    }else{
        self.requestUtil.isShowProgressHud = [self.currBookChapter.url isEqualToString:novelTextUrl];
        [self.requestUtil asyncThirdLibWithUrl:novelTextUrl andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    }
}
//判断本地是否缓存
- (BOOL)isExitNovelByNovelTextUrl:(NSString *)novelTextUrl{
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[novelTextUrl md5]];
    
    if ([NSFileManager isExistsFileWithFilePath:filePath]) {
        
        
        NSError * error = nil;
        
        NSString * text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:&error];
        
        if (![text isEqualToEmptyStr]) {
            return YES;
        }
    }
    
    return NO;
}

//获取需要刷新的下标
- (NSArray<NSNumber *> *)getPreloadDataArrayByCurrentIndex:(NSInteger)currentIndex{
    NSMutableArray<NSNumber *> *reDataArray = [NSMutableArray new];
    
    if (self.dataArray.count>currentIndex) {
        [reDataArray addObject:@(currentIndex)];
    }
    
    
    if (self.dataArray.count>currentIndex+2) {//取后两位
        [reDataArray addObject:@(currentIndex+1)];
        [reDataArray addObject:@(currentIndex+2)];
    }else if (self.dataArray.count==currentIndex+2) {//取前一位
        [reDataArray addObject:@(currentIndex+1)];
        
        if (currentIndex-1>=0) {//加上后一位
            [reDataArray addObject:@(currentIndex+1)];
        }
        
    }else if (currentIndex-2>=0){//取后两位
        [reDataArray addObject:@(currentIndex-1)];
        [reDataArray addObject:@(currentIndex-2)];
    }else if (currentIndex-1==0){
        [reDataArray addObject:@(currentIndex-1)];
    }
    
    return reDataArray;
}

#pragma mark - getter
- (NSMutableArray<BookChapter *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)tmpGetDataDataArray{
    if (!_tmpGetDataDataArray) {
        _tmpGetDataDataArray = [NSMutableArray new];
    }
    return _tmpGetDataDataArray;
}

#pragma mark - 系统协议
- (BOOL)prefersStatusBarHidden{
    return self.navigationController.navigationBarHidden;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenOrShowAllBarAndFooterView];
}

@end
