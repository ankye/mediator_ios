//
//  CustomTremblingView.h
//  testGuoShanChe
//
//  Created by 陈行 on 16/8/5.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTremblingItem.h"

@interface CustomTremblingView : UIView
/**
 *  数据源
 */
@property(nonatomic,strong)NSArray<CustomTremblingItem *> * dataArray;
/**
 *  当前状态
 */
@property(nonatomic,assign,readonly)BOOL isShowStatus;
/**
 *  生成的btnArray
 */
@property(nonatomic,strong)NSMutableArray * btnArray;
/**
 *  取消按钮
 */
@property(nonatomic,weak) UIButton * cancleBtn;

@property(nonatomic,copy)void (^btnClick)(NSInteger index);

@property(nonatomic,copy)void (^cancleBtnClick)();

- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray<CustomTremblingItem *> *)dataArray;
/**
 *  隐藏
 */
- (void)show;
/**
 *  显示
 */
- (void)hidden;

@end
