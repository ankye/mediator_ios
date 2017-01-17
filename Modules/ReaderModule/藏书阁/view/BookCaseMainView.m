//
//  BookCaseMainView.m
//  quread
//
//  Created by 陈行 on 16/11/5.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCaseMainView.h"
#import "BookCaseMainCell.h"

@interface BookCaseMainView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BookCaseMainView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self firstLoad];
}


#pragma mark - 初始加载
- (void)firstLoad{
    self.rowHeight = 100;
    self.dataSource = self;
    self.delegate = self;
    
    //设置背景View
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"empty-page_icon_collect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    imageView.frame=CGRectMake(0, 0, 86, 86);
    imageView.center=backgroundView.center;
    CGRect frame = imageView.frame;
    frame.origin.y=99;
    imageView.frame=frame;
    [backgroundView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+18, WIDTH, 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"你还没有藏书！";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor colorWithRed:0.608 green:0.612 blue:0.690 alpha:1.000];
    [backgroundView addSubview:label];
    
    self.backgroundView=backgroundView;
    //以上设置tableView背景View
    
}

#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.dataArray.count==0){
        self.backgroundView.hidden=NO;
    }else{
        self.backgroundView.hidden=YES;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"BookCaseMainCell";
    BookCaseMainCell * cell=[tableView tableViewCellByNibWithIdentifier:identifier];

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
    [self reloadData];
}

@end
