//
//  BSNumbersView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSNumbersView;

NS_ASSUME_NONNULL_BEGIN

@protocol BSNumbersViewDelegate <NSObject>

@optional

- (nullable NSAttributedString *)numbersView:(BSNumbersView *)numbersView
     attributedStringForHeaderFreezeAtColumn:(NSInteger)column;

- (nullable NSAttributedString *)numbersView:(BSNumbersView *)numbersView
      attributedStringForHeaderSlideAtColumn:(NSInteger)column;

- (nullable NSAttributedString *)numbersView:(BSNumbersView *)numbersView attributedStringForBodyFreezeAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSAttributedString *)numbersView:(BSNumbersView *)numbersView attributedStringForBodySlideAtIndexPath:(NSIndexPath *)indexPath;

- (nullable UIView *)numbersView:(BSNumbersView *)numbersView viewForHeaderFreezeAtColumn:(NSInteger)column;
- (nullable UIView *)numbersView:(BSNumbersView *)numbersView viewForHeaderSlideAtColumn:(NSInteger)column;

- (nullable UIView *)numbersView:(BSNumbersView *)numbersView viewForBodyFreezeAtIndexPath:(NSIndexPath *)indexPath;

- (nullable UIView *)numbersView:(BSNumbersView *)numbersView viewForBodySlideAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BSNumbersView : UIView

@property (assign, nonatomic) id<BSNumbersViewDelegate> delegate;

///min width for each square
@property (assign, nonatomic) CGFloat minItemWidth;

///max width for each square
@property (assign, nonatomic) CGFloat maxItemWidth;

///height for each square
@property (assign, nonatomic) CGFloat itemHeight;

///text horizontal margin for each item, default is 10.0
@property (assign, nonatomic) CGFloat itemTextHorizontalMargin;

///the column need to freeze
@property (assign, nonatomic) NSInteger freezeColumn;

///header font
@property (strong, nonatomic) UIFont *headerFont;

///header text color
@property (strong, nonatomic) UIColor *headerTextColor;

///header background color
@property (strong, nonatomic) UIColor *headerBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *slideBodyFont;

///body text color
@property (strong, nonatomic) UIColor *slideBodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *slideBodyBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *freezeBodyFont;

///body text color
@property (strong, nonatomic) UIColor *freezeBodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *freezeBodyBackgroundColor;

///data
@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;


- (NSString *)textForHeaderFreezeAtColumn:(NSInteger )column;
- (NSString *)textForHeaderSlideAtColumn:(NSInteger )column;

- (NSString *)textForBodyFreezeAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textForBodySlideAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForFreezeAtColumn:(NSInteger )column;
- (CGSize)sizeForSlideAtColumn:(NSInteger )column;

- (void)reloadData;

NS_ASSUME_NONNULL_END

@end
