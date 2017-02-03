//
//  BookDetailBasicCell.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDetailBasicCell.h"
#import "UIImageView+WebCache.h"

@implementation BookDetailBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubLayer:self.goReadBtn];
    [self addSubLayer:self.joinShelfBtn];
    [self addSubLayer:self.allCacheBtn];
    
}

- (void)addSubLayer:(UIButton *)btn{
    btn.layer.borderWidth = SINGLE_LINE_WIDTH;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
}

- (void)setBook:(Book *)book{
    _book = book;
    
    [self.bookCoverImageView sd_setImageWithURL:[NSURL URLWithString:book.novel.cover] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
    self.bookNameLabel.text=book.novel.name;
    
    self.bookAuthorLabel.text = [NSString stringWithFormat:@"作者：%@ | 更新：%@",book.author.name,book.last.timeName];
    
    NSString * joinShelfStr = book.isCaseBook?@"取消藏书":@"加入藏书";
    [self.joinShelfBtn setTitle:joinShelfStr forState:UIControlStateNormal];
    
    NSString * cacheTitle = @"全书缓存";
    self.allCacheBtn.userInteractionEnabled = YES;
    
    if (book.bookCacheStatus == BOOK_CACHE_STATUS_ING) {
        cacheTitle = @"下载中";
    }else if(book.bookCacheStatus == BOOK_CACHE_STATUS_ALL_END){
        cacheTitle = @"缓存成功";
        self.allCacheBtn.userInteractionEnabled = false;
    }
    
    [self.allCacheBtn setTitle:cacheTitle forState:UIControlStateNormal];
    
    
}

@end
