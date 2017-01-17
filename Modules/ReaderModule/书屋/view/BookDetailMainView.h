//
//  BookDetailMainView.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"
#import "Book.h"


@class BookDetailMainView;

@protocol BookDetailMainViewDelegate <NSObject>

- (void)basicFuncBtnClickWithMainView:(BookDetailMainView *)mainView andIndex:(NSInteger)index;

- (void)itemSelectedWithMainView:(BookDetailMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

@end

@interface BookDetailMainView : UITableView

@property(nonatomic,weak) UIButton * allCacheBtn;

@property(nonatomic,strong)Book * book;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,weak)id<BookDetailMainViewDelegate> mainViewDelegate;

@end
