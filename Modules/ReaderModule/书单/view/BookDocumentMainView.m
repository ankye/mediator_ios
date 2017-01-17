//
//  BookDocumentMainView.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDocumentMainView.h"
#import "BookDocumentMainCell.h"

@interface BookDocumentMainView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BookDocumentMainView

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

#pragma mark - 初始加载
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
        weakSelf.oldPage = weakSelf.dataArray.count/SELF_PAGE_COUNT;
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
    static NSString * identifier=@"BookDocumentMainCell";
    BookDocumentMainCell * cell=[tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.bookDocument = self.dataArray[indexPath.row];
    
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

#pragma mark - publish
- (void)addDataArray:(NSArray *)dataArray{
    //结束刷新
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    
    if ([dataArray count]%SELF_PAGE_COUNT!=0) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    
    self.mj_footer.hidden = dataArray.count==0;
    
    if (self.oldPage==0) {
        [self.dataArray removeAllObjects];
    }
    
    _dataArray = _dataArray.count?_dataArray:[NSMutableArray new];
    
    [self.dataArray addObjectsFromArray:dataArray];
    
    [self reloadData];
}


@end
