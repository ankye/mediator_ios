//
//  BookCategoryViewController.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCategoryViewController.h"
#import "BookDetailViewController.h"
#import "BookCategoryListView.h"
#import "BookCollMainView.h"
#import "CustomSliderView.h"
#import "BookCategory.h"
#import "Book.h"

@interface BookCategoryViewController ()<BookCollMainViewDelegate,RootMaskViewDelegate,BookCategoryListViewDelegate>

@property(nonatomic,weak) BookCollMainView * mainView;

@property(nonatomic,weak) BookCategoryListView * categoryListView;

@property(nonatomic,weak) UIView * categoryMaskView;

@property(nonatomic,weak) UIButton * rbtn;

@property(nonatomic,strong)NSMutableArray<BookCategory *> * categoryDataArray;

@property (nonatomic, assign) NSInteger currCategoryIndex;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,assign)BOOL isOriginalOption;

@end

@implementation BookCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadMainView];
    [self loadNavigationBar];
    
    [self downloadBookCategoryData];
}

- (void)loadMainView{
    
    self.requestUtil.isShowProgressHud = false;
    
    BookCollMainView * mainView = [[BookCollMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    [mainView.mj_header beginRefreshing];
    mainView.mainViewDelegate = self;
    [self.view addSubview:mainView];
    self.mainView = mainView;
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, -HEIGHT, WIDTH, HEIGHT)];
    maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
    
    BookCategoryListView * listView = [[BookCategoryListView alloc]initWithFrame:CGRectMake(WIDTH*2/3, 64, WIDTH/3, HEIGHT-64-49) style:UITableViewStyleGrouped];
    listView.mainViewDelegate = self;
    [maskView addSubview:listView];
    [self.view addSubview:maskView];
    self.categoryListView = listView;
    self.categoryMaskView = maskView;
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"全部";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn. frame = CGRectMake(0, 0, 44, 44);
    
    [btn setImage:[UIImage imageNamed:@"nav_option_btn"] forState:UIControlStateNormal];
    
    [btn addTarget: self action:@selector(bookCategoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithCustomView:btn];;
    
    self.navigationItem.rightBarButtonItem = rbbi;
    
    self.rbtn = btn;
    self.isOriginalOption = YES;
}

- (void)bookCategoryBtnClick{
    
    if (self.categoryDataArray.count) {
        
        self.isOriginalOption = !self.isOriginalOption;
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)setIsOriginalOption:(BOOL)isOriginalOption{
    _isOriginalOption = isOriginalOption;
    
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
        
        if (weakSelf.isOriginalOption) {
            weakSelf.rbtn.imageView.transform = CGAffineTransformIdentity;
            weakSelf.categoryMaskView.transform=CGAffineTransformIdentity;
        }else{
            weakSelf.rbtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            weakSelf.categoryMaskView.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
        }
    }];
}

#pragma mark - BookCollMainViewDelegate
- (void)itemSelectedWithMainView:(BookCollMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    
    BookDetailViewController * con = [BookDetailViewController new];
    con.book = mainView.dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)refreshWithMainView:(BookCollMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if (baseView == mainView.mj_header) {
        [self downloadNovelListWithPage:1];
    }else{
        [self downloadNovelListWithPage:mainView.oldPage+1];
    }
}

#pragma mark - BookCategoryListViewDelegate
- (void)itemSelectedCategoryWithMainView:(BookCategoryListView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    
    self.isOriginalOption = !self.isOriginalOption;
    
    [self.dataArray removeAllObjects];
    
    self.currCategoryIndex = indexPath.row;
    
    [self.mainView.mj_header beginRefreshing];
    
    self.navigationItem.title = self.categoryDataArray[indexPath.row].name;
}

#pragma mark - 下载数据
- (void)downloadBookCategoryData{
    NSString * url = URL_GET_BOOK_CATEGORY;
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodPost andTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
}

- (void)downloadNovelListWithPage:(NSInteger)page{
    NSString * bookCategory = @"";
    
    if (self.categoryDataArray.count>self.currCategoryIndex) {
        BookCategory * bc=self.categoryDataArray[self.currCategoryIndex];
        bookCategory = [bc.Id integerValue]!=0?bc.Id:@"";
    }
    
    NSString * url = [NSString stringWithFormat:URL_GET_BOOKNOVEL_BY_CATEGORY,bookCategory,page];
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    if(statusCode==200 && !error){
        
        NSDictionary * dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSInteger errorCode =[dictData[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:dictData[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
        if ([urlString isEqualURLWithURL:URL_GET_BOOK_CATEGORY]) {
            [self.categoryDataArray removeAllObjects];
            
            for (NSDictionary * dict in dictData[@"data"]) {
                [self.categoryDataArray addObject:[BookCategory bookCategoryWithDict:dict]];
            }
            
            self.categoryListView.dataArray = self.categoryDataArray;
        }else if ([urlString isEqualURLWithURL:URL_GET_BOOKNOVEL_BY_CATEGORY]){
            
            self.dataArray = self.mainView.oldPage==0?nil:self.dataArray;
            NSArray * dataArray = dictData[@"data"];
            
            for (NSDictionary * dict in dataArray) {
                [self.dataArray addObject:[Book bookWithDict:dict]];
            }
            self.mainView.dataArray = self.dataArray;

        }
    }else{
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.mainView.mj_header endRefreshing];
        [self.mainView.mj_footer endRefreshing];
        
        [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:FINAL_DATA_REQUEST_FAIL delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

#pragma mark - getter
- (NSMutableArray<BookCategory *> *)categoryDataArray{
    if (!_categoryDataArray) {
        _categoryDataArray = [NSMutableArray new];
    }
    return _categoryDataArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark - 系统协议

@end
