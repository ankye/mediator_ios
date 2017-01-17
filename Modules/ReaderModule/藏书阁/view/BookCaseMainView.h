//
//  BookCaseMainView.h
//  quread
//
//  Created by 陈行 on 16/11/5.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "MainTableView.h"

@class BookCaseMainView;

@protocol BookCaseMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(BookCaseMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

@end

@interface BookCaseMainView : MainTableView

@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,weak)id<BookCaseMainViewDelegate> mainViewDelegate;

@end
