//
//  CustomNumbersRightHeaderView.h
//  myTest
//
//  Created by 陈行 on 16/6/23.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNumbersRightHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeftCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthCon;
@end
