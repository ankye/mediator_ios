//
//  AKHotNovelViewController.m
//  Project
//
//  Created by ankye on 2017/1/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKHotNovelViewController.h"
#import "AKBaseTableView.h"
#import "AKHotNovelHandler.h"

@interface AKHotNovelViewController ()

@property (nonatomic,strong) AKBaseTableView* tableView;
@property (nonatomic,strong) AKHotNovelHandler* handler;
@end

@implementation AKHotNovelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupViews];
    [self setupHandler];
    // Do any additional setup after loading the view.
}

-(void)setupNav
{
    self.navigationItem.title = @"热门小说";
    UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_search_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchNovelBtnClick)];
    self.navigationItem.rightBarButtonItem = rbbi;
    
}

-(void)searchNovelBtnClick
{
    
}

-(void)setupViews
{
    _tableView = [[AKBaseTableView alloc] initWithFrame:CGRectMake(0, SCREEN_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_NAV_HEIGHT-SCREEN_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];

}

-(void)setupHandler
{
    _handler = [[AKHotNovelHandler alloc] init];
    [_handler handleDatasourceAndDelegate:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
