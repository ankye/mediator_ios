//
//  BookCategoryListView.m
//  quread
//
//  Created by 陈行 on 16/11/7.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCategoryListView.h"
#import "UITableView+Category.h"

@interface BookCategoryListView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BookCategoryListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"UITableViewCell";
    
    UITableViewCell * cell = [tableView tableViewCellByClassWithIdentifier:identifier];
    
    cell.textLabel.text = self.dataArray[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mainViewDelegate itemSelectedCategoryWithMainView:self andIndexPath:indexPath];
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)setDataArray:(NSArray<BookCategory *> *)dataArray{
    _dataArray = dataArray;
    
    [self reloadData];
}

@end
