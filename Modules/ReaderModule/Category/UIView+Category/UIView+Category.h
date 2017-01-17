//
//  UIView+Category.h
//  powerlife
//
//  Created by 陈行 on 16/6/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
/**
 *  同名加载xib
 *
 *  @return view
 */
+ (instancetype)viewFromNib;
/**
 *  切角
 *
 *  @param cornerRadius 切角
 */
- (void)layoutCornerRadiusWithCornerRadius:(CGFloat)cornerRadius;
/**
 *  释放自己，以及内部view
 */
- (void)releaseView;
@end
