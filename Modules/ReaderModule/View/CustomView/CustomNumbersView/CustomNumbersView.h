//
//  CustomNumbersView.h
//  myTest
//
//  Created by 陈行 on 16/6/20.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNumbersCell.h"
#import "CustomNumbersModel.h"
@class CustomNumbersView;

@protocol CustomNumbersViewDelegate <NSObject>

@optional
///**
// *  左边view共有多少组
// */
//- (NSInteger)numbersView:(CustomNumbersView *)numbersView numberOfSectionsInLeftView:(UITableView *)leftView;
///**
// *  上边view的cell共有多少个，去掉交叉的一个，默认
// */
//- (NSInteger)numbersView:(CustomNumbersView *)numbersView numberOfItemsInTopView:(UICollectionView *)topView;
///**
// *  左边view的cell共有多少个，去掉交叉的一个
// */
//- (NSInteger)numbersView:(CustomNumbersView *)numbersView numberOfItemsInLeftView:(UITableView *)leftView;
///**
// *  内容区域的view,正常是上边cell个数*左边cell个数
// */
//- (NSInteger)numbersView:(CustomNumbersView *)numbersView numberOfItemsInContentView:(UICollectionView *)contentView;
/**
 *  左上角view
 */
- (UIView *)leftTopViewNumbersView:(CustomNumbersView *)numbersView;
/**
 *  top区域显示的数据
 */
- (UICollectionViewCell *)numbersView:(CustomNumbersView *)numbersView  topCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  left区域显示的数据
 */
- (UITableViewCell *)numbersView:(CustomNumbersView *)numbersView  leftTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  内容区域显示的数据
 */
- (UICollectionViewCell *)numbersView:(CustomNumbersView *)numbersView  conCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CustomNumbersView : UIView

@property(nonatomic,weak)id<CustomNumbersViewDelegate> delegate;
/**
 *  取到空值，显示默认值
 */
@property (nonatomic, copy) NSString *defaultStr;
/**
 *  上边view  key和dataArray
 */
@property (nonatomic, copy) NSString *topKey;
@property(nonatomic,strong)NSMutableArray * topDataArray;
/**
 *  左边用view的数据源
 */
@property(nonatomic,strong)NSMutableArray<CustomNumbersModel *> * leftDataArray;
/**
 *  内容view的数据源
 */
@property(nonatomic,strong)NSMutableArray * conDataArray;
/**
 *  是否高亮显示不同项,默认false
 */
@property(nonatomic,assign)BOOL isShowDiffItem;
/**
 *  不同项的下标，isShowDiffItem为true有效
 */
@property(nonatomic,strong)NSArray * diffItemIndexPathDataArray;
/**
 *  左边view使用，默认100
 */
@property (nonatomic, assign) NSInteger leftItemWidth;
/**
 *  上边view使用，默认44
 */
@property (nonatomic, assign) NSInteger topItemHeight;
/**
 *  内容view使用，上边view使用，默认100
 */
@property (nonatomic, assign) NSInteger conItemWidth;
/**
 *  内容view使用，左边view使用，默认44
 */
@property (nonatomic, assign) NSInteger conItemHeight;
/**
 *  刷新
 */
- (void)reloadData;
/**
 *  topCell所处的下标
 */
- (NSIndexPath *)indexPathWithTopCell:(UICollectionViewCell *)collViewCell;
/**
 *  增加边界
 */
- (void)addBorderColor:(UIView *)view;
@end