//
//  CustomSliderView.h
//  电动生活
//
//  Created by 陈行 on 15-12-15.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomSliderView;

@protocol CustomSliderViewDelegate <NSObject>

- (void)sliderView:(CustomSliderView *)sliderView andIndex:(NSInteger)index andBtnArray:(NSArray *)btnArray;

@end

@interface CustomSliderView : UIScrollView

@property(nonatomic,strong)NSArray * items;

@property(nonatomic,strong,readonly)NSArray * btnArray;

@property (nonatomic, assign) CGFloat btnWidth;

@property(nonatomic,weak)UIView * horiLine;

@property(nonatomic,copy)UIColor * btnBgColor;

@property(nonatomic,copy)UIColor * normalTitleColor;

@property(nonatomic,copy)UIColor * selectedTitleColor;

@property(nonatomic,weak)id<CustomSliderViewDelegate> sliderViewDelegate;

+ (instancetype)sliderViewWithItems:(NSArray *)items andFrame:(CGRect)frame;
- (instancetype)initWithItems:(NSArray *)items andFrame:(CGRect)frame;

- (void)setSelectedBtn:(NSInteger)index;
@end
