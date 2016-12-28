//
//  HSelectionListLabelCell.h
//  HSelectionList Example
//
//  Created by Erik Ackermann on 2/26/15.
//  Copyright (c) 2015 Hightower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSelectionListCell.h"

@interface HSelectionListLabelCell : UICollectionViewCell <HSelectionListCell>

@property (nonatomic, strong) NSString *title;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

+ (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font;

-(void)setSelected:(BOOL)selected;

@end
