//
//  AKBookShelfViewController.m
//  Project
//
//  Created by ankye on 2017/2/4.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookShelfViewController.h"
#import "AKBookShelfHandler.h"
#import "CustomSearchViewController.h"
#import "AKDownloadViewController.h"
#import "AKReaderViewController.h"

@interface AKBookShelfViewController () <AKBaseTableHandlerDelegate,CustomSearchViewControllerDelegate>

@property (nonatomic,strong) AKBaseTableView* tableView;
@property (nonatomic,strong) AKBookShelfHandler* handler;

@end

@implementation AKBookShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupViews];
    [self setupHandler];
   
    // Do any additional setup after loading the view.
}

-(void)setupNav
{
    self.navigationItem.title = @"追书猫";
    UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"download"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(downloadManagerBtnClick)];
    self.navigationItem.rightBarButtonItem = rbbi;
    
    UIBarButtonItem * leftBi = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_search_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchNovelBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBi;
    
}




-(void)downloadManagerBtnClick
{
    AKDownloadViewController *controller = [AKDownloadViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)searchNovelBtnClick
{
    CustomSearchViewController * con = [CustomSearchViewController new];
    con.delegate = self;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - CustomSearchViewController
- (void)searchViewControllerSearchButtonClicked:(CustomSearchViewController *)controller andSearchValue:(NSString *)searchValue{
    //    [controller.navigationController popViewControllerAnimated:NO];
    //
    //    BookSearchViewController * con = [BookSearchViewController new];
    //
    //    con.searchKey = searchValue;
    //    [self.navigationController pushViewController:con animated:YES];
}

- (void)searchViewControllerCancleButtonClicked:(CustomSearchViewController *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}


-(void)setupViews
{
    _tableView = [[AKBaseTableView alloc] initWithFrame:CGRectMake(0, SCREEN_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_NAV_HEIGHT-SCREEN_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_offset(SCREEN_NAV_HEIGHT);
    }];
    
  

    
}

-(void)showTips:(AKPopupPriority)priority withTitle:(NSString*)title
{
 
    AKPopupAttributes* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleFormSheet actionType:AKPopupActionTypeFade onClick:^(NSInteger channel, NSDictionary *extend) {
        NSLog(@"确定点击");
        if(channel == 2){
            
        }
    } onClose:^(NSDictionary *extend) {
        NSLog(@"确定关闭");
    } onCompleted:^(NSDictionary *extend) {
        NSLog(@"关闭完成");
    }];
    
    attributes.priority = priority;
    
    [[AKPopupManager sharedInstance] showChooseAlert:title withDetail:@"删除后需要重新下载！" withItems:nil withAttributes:attributes];
}

-(void)setupHandler
{
    _handler = [[AKBookShelfHandler alloc] init];
    [_handler handleDatasourceAndDelegate:_tableView];
    _handler.handlerDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Y轴滚动偏移
- (void)tableDidScrollWithOffsetY:(float)offsetY
{
    
}
//Y轴结束拖动
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity
{
    
}
//刷新
- (void)handlerRefreshing:(id)handler
{
    
}
//选择某一行
- (void)didSelectSection:(NSInteger)section withRow:(NSInteger)row withContent:(NSObject* )content
{
    Book* book = (Book*)content;
    
    AKReaderViewController *readerVC = [AKReaderViewController new];
    readerVC.book = book;
    readerVC.hidesBottomBarWhenPushed = YES;
    
    [self.rt_navigationController pushViewController:readerVC animated:YES];
}

-(void)didSectionClick:(NSInteger)section withRow:(NSInteger)row withClickChannel:(NSInteger)clickChannel withContent:(NSObject *)content
{
    
}

@end
