//
//  BookReadMainCell.h
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"

@interface BookReadMainCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;

@property (weak, nonatomic) IBOutlet UIView *electricityView;

@property (weak, nonatomic) IBOutlet UILabel *pagesLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualBatteryWidthCon;

@property (weak, nonatomic) IBOutlet UIView *placeholdView;

@property (weak, nonatomic) IBOutlet UILabel *placeholdChapterNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property(nonatomic,strong)BookChapter * bookChapter;

@end
