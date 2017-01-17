//
//  RootMaskView.h
//  powerlife
//
//  Created by 陈行 on 16/6/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootStandardTableCell.h"
@class RootMaskView;

@protocol RootMaskViewDelegate <NSObject>

@required


@optional

- (NSInteger)numberOfSectionsInMaskView:(RootMaskView *)maskView;

- (NSInteger)maskView:(RootMaskView *)maskView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)maskView:(RootMaskView *)maskView andTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)maskView:(RootMaskView *)maskView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIView *)maskView:(RootMaskView *)maskView andTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (CGFloat)maskView:(RootMaskView *)maskView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)maskView:(RootMaskView *)maskView heightForHeaderInSection:(NSInteger)section;

- (CGFloat)maskView:(RootMaskView *)maskView heightForFooterInSection:(NSInteger)section;

@end

@interface RootMaskView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray * dataArray;
@property (nonatomic, copy) NSString *key;

@property(nonatomic,weak)id<RootMaskViewDelegate> delegate;

/**
 *  初始化
 *
 *  @param superView 当前view的父view
 *  @param subView   要添加的view
 *
 *  @return 当前view
 */
+ (instancetype)maskViewWithSuperView:(UIView *)superView;
/**
 *  显示view
 */
- (void)showView;
/**
 *  隐藏view
 *
 *  @param animation 是否动画
 */
- (void)hiddenViewWithAnimation:(BOOL)animation;
/**
 *  初始选中某个
 */
- (void)selectedIndexPath:(NSIndexPath *)indexPath;
/**
 *  取消选中
 */
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end
