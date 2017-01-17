//
//  BookDocumentMainCell.h
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDocument.h"

@interface BookDocumentMainCell : UITableViewCell

/**
 *  书单封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *bookListCoverImageView;
/**
 *  书单名称
 */
@property (weak, nonatomic) IBOutlet UILabel *bookListNameLabel;
/**
 *  书单介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *bookListIntroduceLabel;

@property(nonatomic,strong)BookDocument * bookDocument;

@end
