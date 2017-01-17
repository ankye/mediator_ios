//
//  CustomPickView.h
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPickView;

@protocol CustomPickViewDelegate <NSObject>

- (void)customPickView:(CustomPickView *)customPickView andSelectedArray:(NSArray *)selectedArray andDataArray:(NSArray *)dataArray;

@optional
- (void)customPickViewCancleTouch:(CustomPickView *)customPickView;

@end

@interface CustomPickView : UIView

@property(nonatomic,weak)UIPickerView * pickView;

@property(nonatomic,copy)NSString * titleKey;
/**
 *  isDependPre为true的时候 对象key
 */
@property(nonatomic,copy)NSArray * dataArrayKey;

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)NSMutableArray * selectedArray;
/**
 *  isDependPre为false的时候 对象key
 */
@property(nonatomic,copy)NSArray * keyArray;

@property(nonatomic,weak)id<CustomPickViewDelegate>delegate;

+ (instancetype)customPickViewWithDataArray:(NSArray *)dataArray andComponent:(NSInteger)component andIsDependPre:(BOOL)isDependPre andFrame:(CGRect)frame;

- (void)customPickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)reloadSelectArray;

@end
