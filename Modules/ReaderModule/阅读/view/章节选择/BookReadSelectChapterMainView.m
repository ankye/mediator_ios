//
//  BookReadSelectChapterMainView.m
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadSelectChapterMainView.h"
#import "BookReadSelectChapterMainCell.h"

@interface BookReadSelectChapterMainView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation BookReadSelectChapterMainView

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
    static NSString * identifier=@"BookReadSelectChapterMainCell";
    BookReadSelectChapterMainCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        UINib * nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
    
    BookChapter * bookChapter = self.dataArray[indexPath.row];
    
    cell.chapterNameLabel.text = bookChapter.name;
    
    if (self.currentIndex == indexPath.row) {
        cell.statusImageView.image = [UIImage imageNamed:@"blue_choose"];
    }else if(bookChapter.isTmp){
        cell.statusImageView.image = [UIImage imageNamed:@"point_select_green"];
    }else{
        cell.statusImageView.image = [UIImage imageNamed:@"point_unselect"];
    }
    
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

#pragma mark - setter
- (void)setDataArray:(NSArray<BookChapter *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
    
    if (self.dataArray.count > self.currentIndex) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

@end
