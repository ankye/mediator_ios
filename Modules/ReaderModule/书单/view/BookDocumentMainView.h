//
//  BookDocumentMainView.h
//  quread
//
//  Created by 陈行 on 16/11/3.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "MainTableView.h"

@class BookDocumentMainView;

#define SELF_PAGE_COUNT 10l

@protocol BookDocumentMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(BookDocumentMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)refreshWithMainView:(BookDocumentMainView *)mainView andRefreshComponent:(MJRefreshComponent *)baseView;

@end

@interface BookDocumentMainView : MainTableView

@property(nonatomic,readonly,strong)NSMutableArray * dataArray;

@property (nonatomic, assign) NSInteger oldPage;

@property(nonatomic,weak)id<BookDocumentMainViewDelegate> mainViewDelegate;

- (void)addDataArray:(NSArray *)dataArray;

@end
