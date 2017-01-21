//
//  AKDownloadViewController.m
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDownloadViewController.h"
#import "AKDownloadTableHandler.h"

@interface AKDownloadViewController()  <AKBaseTableHandlerDelegate>

@property (nonatomic,strong) AKBaseTableView* tableView;
@property (nonatomic,strong) AKDownloadTableHandler* handler;

@end

@implementation AKDownloadViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupViews];
    [self setupHandler];
    
}
-(void)setupNav
{
    self.navigationItem.title = @"下载管理";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.navigationController.navigationBar.barTintColor= [UIColor colorWithHexString:@"#3c93d6"];
    //设置字体颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
}
-(void)setupViews
{
    _tableView = [[AKBaseTableView alloc] initWithFrame:CGRectMake(0, SCREEN_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_NAV_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.enableLoadMore = NO;
    _tableView.enableLoadNew = NO;
    [self.view addSubview:_tableView];
    
}

-(void)setupHandler
{
    _handler = [[AKDownloadTableHandler alloc] init];
    [_handler handleDatasourceAndDelegate:_tableView];
    _handler.handlerDelegate = self;
    [_handler refresh];
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
    
}

//section的row的action触发
-(void)didSectionClick:(NSInteger)section withRow:(NSInteger)row withClickChannel:(NSInteger)clickChannel withContent:(NSObject*)content
{
    
}


@end
