//
//  BookCollMainView.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCollMainView.h"
#import "UITableView+Category.h"

@interface BookCollMainView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BookCollMainView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self firstLoad];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self firstLoad];
    }
    return self;
}

#pragma mark - 首次加载
- (void)firstLoad{
    self.dataSource = self;
    self.delegate = self;
    self.rowHeight = 100;
    self.oldPage = 0;
    
    __block typeof(self) weakSelf = self;
    
    [self headerWithRefreshingBlock:^{
        weakSelf.oldPage = 0;
        [weakSelf.mainViewDelegate refreshWithMainView:weakSelf andRefreshComponent:weakSelf.mj_header];
    }];
    
    [self footerWithRefreshingBlock:^{
        weakSelf.oldPage = weakSelf.dataArray.count/DATA_PAGE_SIZE_20;
        [weakSelf.mainViewDelegate refreshWithMainView:weakSelf andRefreshComponent:weakSelf.mj_footer];
    }];
    self.mj_footer.hidden = YES;
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"BookCollMainCell";
    BookCollMainCell * cell=[tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.book = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.oldPage = dataArray.count/DATA_PAGE_SIZE_20;
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self reloadData];
    
    self.mj_footer.hidden = dataArray.count==0;
    
    if(dataArray.count && [dataArray count]%DATA_PAGE_SIZE_20!=0){
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
}

@end
