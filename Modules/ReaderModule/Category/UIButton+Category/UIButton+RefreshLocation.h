//
//  UIButton+RefreshLocation.h
//  电动生活
//
//  Created by 陈行 on 15-12-23.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RefreshLocation)

/**
 *  图片在上边
 *  文字在下边
 */
- (void)refreshTopBottom;
/**
 *  图片在下边
 *  文字在上边
 */
- (void)refreshBottomTop;
/**
 *  图片在右边
 *  文字在左边
 */
- (void)refreshRightLeft;
/**
 *  已经用refresh刷新过不满意，可以调用此方法在原来基础上再次增加
 *
 *  @param top    上边
 *  @param bottom 下边
 *  @param left   左边
 *  @param right  右边
 */
- (void)refreshImageViewWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

- (void)refreshTitleLabelWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

@end
