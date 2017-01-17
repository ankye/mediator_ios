//
//  BookReadSelectChapterMainView.h
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapter.h"
@class BookReadSelectChapterMainView;

@protocol BookReadSelectChapterMainViewDelegate <NSObject>

- (void)itemSelectedWithMainView:(BookReadSelectChapterMainView *)mainView andIndexPath:(NSIndexPath *)indexPath;

@end

@interface BookReadSelectChapterMainView : UITableView

@property (nonatomic, assign) NSInteger currentIndex;

@property(nonatomic,strong)NSArray<BookChapter *> * dataArray;

@property(nonatomic,weak)id<BookReadSelectChapterMainViewDelegate> mainViewDelegate;

@end
