//
//  BookDetailBasicCell.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookDetailBasicCell : UITableViewCell
/**
 *  小说封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
/**
 *  小说名称
 */
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
/**
 *  作者信息及最后更新信息
 */
@property (weak, nonatomic) IBOutlet UILabel *bookAuthorLabel;
/**
 *  分类
 */
@property (weak, nonatomic) IBOutlet UILabel *bookCategoryLabel;
/**
 *  立即阅读btn
 */
@property (weak, nonatomic) IBOutlet UIButton *goReadBtn;
/**
 *  加入书架
 */
@property (weak, nonatomic) IBOutlet UIButton *joinShelfBtn;
/**
 *  全本缓存
 */
@property (weak, nonatomic) IBOutlet UIButton *allCacheBtn;

@property(nonatomic,strong)Book * book;

@end
