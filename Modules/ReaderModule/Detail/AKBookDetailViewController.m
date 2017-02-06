//
//  AKBookDetailViewController.m
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookDetailViewController.h"
#import "AKBookDetailHandler.h"
#import "BookDatabase.h"
#import "AKReaderViewController.h"

@interface AKBookDetailViewController () <AKBaseTableHandlerDelegate>

@property (nonatomic,strong) AKBaseTableView* tableView;
@property (nonatomic,strong) AKBookDetailHandler* handler;

/**
 *  是否在底部
 */
@property(nonatomic,assign)BOOL isBottom;


@end

@implementation AKBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupViews];

    [self setupHandler];
    
    [AKPopupManager showProgressHUDAtView:_tableView];

}

-(void) setupNav
{
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
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height) animated:YES];
    }else{
        [rightBtn setTitle:@"底部" forState:UIControlStateNormal];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}



-(void) setupViews
{
    _tableView = [[AKBaseTableView alloc] initWithFrame:CGRectMake(0, SCREEN_NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_NAV_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.enableLoadMore = NO;
    _tableView.enableLoadNew = NO;
    [self.view addSubview:_tableView];
    
}

-(void)setupHandler
{
    _handler = [[AKBookDetailHandler alloc] init];
    [_handler handleDatasourceAndDelegate:_tableView];
    _handler.handlerDelegate = self;
    _handler.book = self.book;
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
    if (section == 0 &&  clickChannel ==0) {
//        BookReadViewController * con = [BookReadViewController new];
//        con.book = _handler.book;
//        con.dataArray = _handler.dataList;
//        
        AKReaderViewController *reader = [AKReaderViewController new];
        reader.book = _handler.book;
        reader.chapterArray = _handler.dataList;

//        [self presentViewController:reader animated:YES completion:^{
//            
//        }];
        [self.navigationController pushViewController:reader animated:YES];
        
        
    }else if (section == 0 &&clickChannel == 1){
       
    }else if (section == 0 && clickChannel ==2 ){//共三个状态
       
    }

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
