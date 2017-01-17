//
//  BookReadMainView.m
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadMainView.h"
#import "BookReadMainCell.h"
#import "UICollectionView+Category.h"

@interface BookReadMainView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) BookReadMainCell * currentCell;

@property (nonatomic, assign) NSInteger currentReadIndex;

@end

@implementation BookReadMainView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource=self;
        self.delegate=self;
        self.pagingEnabled = YES;
        self.backgroundColor = READ_BACKGROUND_COLOR;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray[section].textDataArray.count==0?1:self.dataArray[section].textDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSInteger count = 1;
//    NSLog(@"-------->%ld",count++);
    
    static NSString * identifier = @"BookReadMainCell";
    BookReadMainCell * cell =[collectionView collectionViewCellByNibWithIdentifier:identifier andIndexPath:indexPath];
    
    BookChapter * bookChapter = self.dataArray[indexPath.section];
    
    if (bookChapter.textDataArray.count==0) {
        cell.placeholdView.hidden = YES;
        cell.chapterNameLabel.text = bookChapter.name;
        cell.placeholdChapterNameLabel.text = bookChapter.name;
        
        cell.pagesLabel.text = @"第1/1页";
        
        [cell.reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.textLabel.text = @"";
        
        self.currentCell = cell;
        [self.mainViewDelegate requestDataWithMainView:self andCurrIndex:indexPath.section];
    }else{
        cell.placeholdView.hidden = YES;
        cell.chapterNameLabel.text = bookChapter.name;
        
        NSString * text = bookChapter.textDataArray[indexPath.row];
        
        cell.textLabel.text= text;
        
        cell.pagesLabel.text = [NSString stringWithFormat:@"第%ld/%ld页",indexPath.row+1,bookChapter.textDataArray.count];
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //调整行间距
        [paragraphStyle setLineSpacing:READ_TEXT_SPACE];
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        
        cell.textLabel.attributedText = attributedString;
    }
    
//    if (indexPath.row==0) {
//        [self.mainViewDelegate requestDataWithMainView:self andCurrIndex:indexPath.section];
//    }
    
    cell.bookChapter = bookChapter;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    [self.mainViewDelegate itemSelectedWithMainView:self andIndexPath:indexPath];
}

#pragma mark - private
- (void)reloadBtnClick:(UIButton *)reloadBtn{
    BookReadMainCell * cell = (BookReadMainCell *) reloadBtn.superview.superview.superview;
    
    BookChapter * bookChapter = cell.bookChapter;
    
    NSInteger currIndex = [self.dataArray indexOfObject:bookChapter];
    
    [self.mainViewDelegate requestDataWithMainView:self andCurrIndex:currIndex];
}

#pragma mark - setter
- (void)setDataArray:(NSArray<BookChapter *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

- (void)setGetNullDataForCellWithUrl:(NSString *)url{
    if ([self.currentCell.bookChapter.url isEqualToString:url]) {
        self.currentCell.placeholdView.hidden = NO;
        self.currentCell = nil;
    }
}

@end
