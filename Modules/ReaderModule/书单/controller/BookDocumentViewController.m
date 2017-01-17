//
//  BookDocumentViewController.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDocumentViewController.h"
#import "BookListDetailViewController.h"
#import "BookDocumentMainView.h"

#import "BookDocument.h"

@interface BookDocumentViewController ()<BookDocumentMainViewDelegate>

@property(nonatomic,weak) BookDocumentMainView * mainView;

@end

@implementation BookDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMainView];
    [self loadNavigationBar];
}

- (void)loadMainView{
    self.requestUtil.isShowProgressHud = false;
    
    BookDocumentMainView * mainView = [[BookDocumentMainView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    mainView.mainViewDelegate = self;
    [mainView.mj_header beginRefreshing];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"热门书单";
}

#pragma mark - BookDocumentMainViewDelegate
- (void)itemSelectedWithMainView:(BookDocumentMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    BookListDetailViewController * con = [BookListDetailViewController new];
    con.bookDocument = mainView.dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)refreshWithMainView:(BookDocumentMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if (baseView == mainView.mj_header) {
        [self downloadBookDocListWithPage:1];
    }else{
        [self downloadBookDocListWithPage:mainView.oldPage+1];
    }
}

#pragma mark - 下载数据
- (void)downloadBookDocListWithPage:(NSInteger)page{
    
    NSString * url = [NSString stringWithFormat:URL_GET_BOOKDOCUMENT_LIST,page];
    [self.requestUtil asyncThirdLibWithUrl:url andParameters:nil andMethod:RequestMethodGet andTimeoutInterval:10];
}

- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString{
    if(statusCode==200 && !error){
        
        NSDictionary * dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSInteger errorCode =[dictData[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:dictData[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
        if ([urlString isEqualURLWithURL:URL_GET_BOOKDOCUMENT_LIST]) {
            NSMutableArray * dataArray = [NSMutableArray new];
            
            for (NSDictionary * dict in dictData[@"data"]) {
                [dataArray addObject:[BookDocument bookDocumentWithDict:dict]];
            }
            
            [self.mainView addDataArray:dataArray];
        }
        
    }else{
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.mainView.mj_header endRefreshing];
        [self.mainView.mj_footer endRefreshing];
        
        [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:FINAL_DATA_REQUEST_FAIL delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

@end
