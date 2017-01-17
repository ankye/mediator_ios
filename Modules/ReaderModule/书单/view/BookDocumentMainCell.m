//
//  BookDocumentMainCell.m
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookDocumentMainCell.h"
#import "UIImageView+WebCache.h"

@implementation BookDocumentMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setBookDocument:(BookDocument *)bookDocument{
    _bookDocument = bookDocument;
    
    self.bookListNameLabel.text = bookDocument.name;
    
    self.bookListIntroduceLabel.text = bookDocument.intro;
    
    [self.bookListCoverImageView sd_setImageWithURL:[NSURL URLWithString:bookDocument.cover] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
}

@end
