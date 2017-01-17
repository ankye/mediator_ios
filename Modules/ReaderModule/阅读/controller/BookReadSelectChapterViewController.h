//
//  BookReadSelectChapterViewController.h
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "RootViewController.h"
@class BookReadSelectChapterViewController;

@protocol BookReadSelectChapterViewControllerDelegate <NSObject>

- (void)selectedNewChapterWithCon:(BookReadSelectChapterViewController *)con andIndex:(NSInteger)index;

@end

@interface BookReadSelectChapterViewController : RootViewController

@property(nonatomic,strong)NSArray * dataArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *bookNovelId;

@property(nonatomic,weak)id<BookReadSelectChapterViewControllerDelegate> delegate;

@end
