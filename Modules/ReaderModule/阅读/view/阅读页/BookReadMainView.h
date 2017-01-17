//
//  BookReadMainView.h
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"

@class BookReadMainView;

@protocol BookReadMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(BookReadMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

- (void)requestDataWithMainView:(BookReadMainView *)mainView  andCurrIndex:(NSInteger)currIndex;

@end

@interface BookReadMainView : UICollectionView

@property(nonatomic,strong)NSArray<BookChapter *> * dataArray;

@property(nonatomic,weak)id<BookReadMainViewDelegate> mainViewDelegate;

- (void)setGetNullDataForCellWithUrl:(NSString *)url;

@end
