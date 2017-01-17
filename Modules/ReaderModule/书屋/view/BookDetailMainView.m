//
//  BookDetailMainView.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDetailMainView.h"
#import "BookDetailBasicCell.h"
#import "BookDetailIntroduceCell.h"
#import "BookDetailChapterCell.h"
#import "UITableView+Category.h"

@interface BookDetailMainView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BookDetailMainView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
}


#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section<2) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * identifier=@"BookDetailBasicCell";
        BookDetailBasicCell * cell=[tableView tableViewCellByNibWithIdentifier:identifier];
        [cell.goReadBtn addTarget:self action:@selector(goReadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.allCacheBtn addTarget:self action:@selector(allCacheBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.joinShelfBtn addTarget:self action:@selector(joinShelfBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.book = self.book;
        self.allCacheBtn = cell.allCacheBtn;
        return cell;
    }else if(indexPath.section==1){
        static NSString * identifier=@"BookDetailIntroduceCell";
        BookDetailIntroduceCell * cell=[tableView tableViewCellByNibWithIdentifier:identifier];
        cell.bookIntroduceLabel.text = self.book.novel.intro;
        return cell;
    }else{
        static NSString * identifier = @"BookDetailChapterCell";
        BookDetailChapterCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        BookChapter * bookChapter = self.dataArray[indexPath.row];
        
        cell.indexLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        
        cell.chapterNameLabel.text = bookChapter.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section>1) {
        [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
    }else if(indexPath.section==0){
        [self goReadBtnClick:nil];
    }
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
    }else if(indexPath.section==1){
        return self.book.novel.introHeight+60;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - private
- (void)goReadBtnClick:(UIButton *)btn{
    [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:0];
}
- (void)joinShelfBtnClick:(UIButton *)btn{
    [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:1];
    [self reloadData];
}
- (void)allCacheBtnClick:(UIButton *)btn{
    [self.mainViewDelegate basicFuncBtnClickWithMainView:self andIndex:2];
}

#pragma mark - setter
- (void)setBook:(Book *)book{
    _book = book;
    [self reloadData];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

@end
