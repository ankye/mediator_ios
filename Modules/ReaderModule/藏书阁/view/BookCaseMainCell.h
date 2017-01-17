//
//  BookCaseMainCell.h
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookCaseMainCell : UITableViewCell

/**
 *  小说封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
/**
 *  小说名称
 */
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hasNewChapterImageView;

@property (weak, nonatomic) IBOutlet UILabel *bookUpdateChapterLabel;

@property (weak, nonatomic) IBOutlet UILabel *bookLastUpdateTimeLabel;

@property(nonatomic,strong)Book * book;

@end
