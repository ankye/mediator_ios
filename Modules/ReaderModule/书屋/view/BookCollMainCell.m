//
//  BookCollMainCell.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookCollMainCell.h"
#import "UIImageView+WebCache.h"

@implementation BookCollMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBook:(Book *)book{
    _book = book;

    [self.bookCoverImageView sd_setImageWithURL:[NSURL URLWithString:book.novel.cover] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
    self.bookNameLabel.text= book.novel.name;
    
    self.bookIntroduceLabel.text = book.novel.intro;
}

@end
