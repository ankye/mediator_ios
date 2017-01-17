//
//  SearchViewController.h
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomSearchViewController;

@protocol CustomSearchViewControllerDelegate <NSObject>

- (void)searchViewControllerSearchButtonClicked:(CustomSearchViewController *)controller andSearchValue:(NSString *)searchValue;

- (void)searchViewControllerCancleButtonClicked:(CustomSearchViewController *)controller;

@end

@interface CustomSearchViewController : UIViewController

@property (nonatomic , weak)id<CustomSearchViewControllerDelegate> delegate;

@end
