//
//  BookCaseMainCell.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCaseMainCell.h"
#import "UIImageView+WebCache.h"

@implementation BookCaseMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hasNewChapterImageView.hidden = YES;
}

- (void)setBook:(Book *)book{
    _book = book;
    
    [self.bookCoverImageView sd_setImageWithURL:[NSURL URLWithString:book.novel.cover] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
    self.bookNameLabel.text= book.novel.name;
    
    self.bookUpdateChapterLabel.text = book.last.name;
    
    self.bookLastUpdateTimeLabel.text = book.last.timeName;
    
    self.hasNewChapterImageView.hidden = !book.last.isNewChapter;
    
}


@end
