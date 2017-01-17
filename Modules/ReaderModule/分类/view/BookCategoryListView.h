//
//  BookCategoryListView.h
//  quread
//
//  Created by 陈行 on 16/11/7.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "MainTableView.h"
#import "BookCategory.h"

@class BookCategoryListView;

@protocol BookCategoryListViewDelegate <NSObject>

- (void)itemSelectedCategoryWithMainView:(BookCategoryListView *)mainView andIndexPath:(NSIndexPath *)indexPath;

@end

@interface BookCategoryListView : MainTableView

@property(nonatomic,strong)NSArray<BookCategory *> * dataArray;

@property(nonatomic,weak)id<BookCategoryListViewDelegate> mainViewDelegate;

@end
