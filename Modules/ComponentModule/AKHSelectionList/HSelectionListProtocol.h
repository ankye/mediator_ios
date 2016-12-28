//
//  HSelectionListProtocol.h
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HSelectionListDataSource;
@protocol HSelectionListDelegate;


@protocol HSelectionListProtocol <NSObject>

@property (nonatomic) NSInteger selectedButtonIndex;

@property (nonatomic, weak, nullable) id<HSelectionListDataSource> dataSource;
@property (nonatomic, weak, nullable) id<HSelectionListDelegate> delegate;


- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated;

@end

@protocol HSelectionListDataSource <NSObject>

- (NSInteger)numberOfItemsInSelectionList:(_Nonnull id<HSelectionListProtocol>)selectionList;

@optional
- (nullable NSString *)selectionList:(_Nonnull id<HSelectionListProtocol>)selectionList titleForItemWithIndex:(NSInteger)index;
- (nullable UIView *)selectionList:(_Nonnull id<HSelectionListProtocol>)selectionList viewForItemWithIndex:(NSInteger)index;

- (nullable NSString *)selectionList:(_Nonnull id<HSelectionListProtocol>)selectionList badgeValueForItemWithIndex:(NSInteger)index;

@end

@protocol HSelectionListDelegate <NSObject>

- (void)selectionList:(_Nonnull id<HSelectionListProtocol>)selectionList didSelectButtonWithIndex:(NSInteger)index;

@end
