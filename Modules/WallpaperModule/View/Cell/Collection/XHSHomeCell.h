//
//  XHSHomeCell.h
//  小红书
//
//  Created by Aesthetic92 on 16/7/9.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSHomeModel;

static NSString *identifier_XHSHomeCell = @"HomeCell" ;



@interface XHSHomeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iv;

@property(nonatomic, strong) XHSHomeModel *model;


@end
