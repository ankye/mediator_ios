//
//  BookCollViewController.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCollViewController.h"
#import "BookDetailViewController.h"
#import "CustomSearchViewController.h"
#import "BookSearchViewController.h"
#import "BookCollMainView.h"

@interface BookCollViewController ()<BookCollMainViewDelegate,CustomSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet BookCollMainView *mainView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation BookCollViewController

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
}

- (void)loadMainView{
    self.mainView.mainViewDelegate = self;
    [self.mainView.mj_header beginRefreshing];
}

- (void)loadNavigationBar{
    self.navigationItem.title = @"热门小说";
    UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_search_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchNovelBtnClick)];
    self.navigationItem.rightBarButtonItem = rbbi;
}

- (void)searchNovelBtnClick{
    CustomSearchViewController * con = [CustomSearchViewController new];
    con.delegate = self;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - BookCollMainViewDelegate
- (void)itemSelectedWithMainView:(BookCollMainView *)mainView andIndexPath:(NSIndexPath *)indexPath{
    BookDetailViewController * con = [BookDetailViewController new];
    con.book = mainView.dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)refreshWithMainView:(BookCollMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView{
    if (baseView == mainView.mj_header) {
        [self downloadHotNoteListWithPage:1];
    }else{
        [self downloadHotNoteListWithPage:mainView.oldPage+1];
    }
}

#pragma mark - CustomSearchViewController
- (void)searchViewControllerSearchButtonClicked:(CustomSearchViewController *)controller andSearchValue:(NSString *)searchValue{
    [controller.navigationController popViewControllerAnimated:NO];
    
    BookSearchViewController * con = [BookSearchViewController new];
    
    con.searchKey = searchValue;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)searchViewControllerCancleButtonClicked:(CustomSearchViewController *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下载数据
- (void)downloadHotNoteListWithPage:(NSInteger)page{
    NSString * url = [NSString stringWithFormat:URL_GET_HOT_NOTE_LIST,page];
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
        
        if ([urlString isEqualURLWithURL:URL_GET_HOT_NOTE_LIST]) {
            
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


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.requestUtil.isShowProgressHud = false;
    self.navigationController.navigationBarHidden = false;
}


@end
