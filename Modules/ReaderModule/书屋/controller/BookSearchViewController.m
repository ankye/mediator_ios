//
//  BookSearchViewController.m
//  quread
//
//  Created by 陈行 on 16/11/2.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BookDetailViewController.h"
#import "BookCollMainView.h"

@interface BookSearchViewController ()<BookCollMainViewDelegate>

@property(nonatomic,weak) BookCollMainView * mainView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
}

- (void)loadMainView{
    self.requestUtil.isShowProgressHud = false;
    
    BookCollMainView * mainView = [[BookCollMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    [mainView.mj_header beginRefreshing];
    mainView.mainViewDelegate = self;
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"搜索小说";
}

#pragma mark - BookCollMainViewDelegate
- (void)itemSelectedWithMainView:(BookCollMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    
    BookDetailViewController * con = [BookDetailViewController new];
    con.book = mainView.dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)refreshWithMainView:(BookCollMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if (baseView == mainView.mj_header) {
        [self downloadSearchNovelListWithPage:1];
    }else{
        [self downloadSearchNovelListWithPage:mainView.oldPage+1];
    }
}

#pragma mark - 下载数据
- (void)downloadSearchNovelListWithPage:(NSInteger)page{
    NSString * url = [NSString stringWithFormat:URL_GET_SEARCH_NOVEL_LIST,self.searchKey,page];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        
        if ([urlString isEqualURLWithURL:URL_GET_SEARCH_NOVEL_LIST]) {
            
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
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
