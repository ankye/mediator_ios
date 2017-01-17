//
//  BookCollMainView.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCollMainCell.h"
#import "MainTableView.h"
@class BookCollMainView;

@protocol BookCollMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(BookCollMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(BookCollMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface BookCollMainView : MainTableView

@property (nonatomic, assign) NSInteger oldPage;

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<BookCollMainViewDelegate> mainViewDelegate;

@end
