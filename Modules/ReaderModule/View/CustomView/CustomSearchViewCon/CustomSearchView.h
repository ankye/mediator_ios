//
//  CustomSearchBar.h
//  TestSearchViewController
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEARCHTEXT @"CustomSearchBarSearchText"

@class CustomSearchView;

@protocol CustomSearchViewDelegate <NSObject>

- (void)customSearchBar:(CustomSearchView *)searchView andSearchValue:(NSString *)searchValue;

- (void)customSearchBar:(CustomSearchView *)searchView andCancleBtn:(UIButton *)cancleBtn;

@end

@interface CustomSearchView : UIView
/**
 *  默认5
 */
@property (nonatomic, assign) NSInteger maxRowCount;

@property(nonatomic,weak)id<CustomSearchViewDelegate>delegate;

@end
