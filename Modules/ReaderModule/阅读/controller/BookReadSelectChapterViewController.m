//
//  BookReadSelectChapterViewController.m
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadSelectChapterViewController.h"
#import "BookReadSelectChapterMainView.h"
#import "NSFileManager+FileCategory.h"

@interface BookReadSelectChapterViewController ()<BookReadSelectChapterMainViewDelegate>

@property(nonatomic,weak)BookReadSelectChapterMainView * mainView;

@property(nonatomic,assign)BOOL isBottom;

@end

@implementation BookReadSelectChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self loadNavigationBar];
}

- (void)loadMainView{
    
    BookReadSelectChapterMainView * mainView = [[BookReadSelectChapterMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    mainView.currentIndex = self.currentIndex;
    mainView.mainViewDelegate = self;
    
    [self.view addSubview:mainView];
    self.mainView = mainView;
    
    
    __block typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSLog(@"-------->%@",[NSDate date]);
    dispatch_async(dispatch_get_main_queue(), ^{
    
        for (BookChapter * bookChapter in weakSelf.dataArray) {
            
            NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,weakSelf.bookNovelId,[bookChapter.url md5]];
            
            bookChapter.isTmp = [NSFileManager isExistsFileWithFilePath:filePath];
        }
        NSLog(@"-------->%@",[NSDate date]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.mainView.dataArray = weakSelf.dataArray;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        });
        
    });
    
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"章节选择";
    
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

#pragma mark - BookReadSelectChapterMainViewDelegate
- (void)itemSelectedWithMainView:(BookReadSelectChapterMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    [self.delegate selectedNewChapterWithCon:self andIndex:indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
