//
//  BookReadViewController.h
//  quread
//
//  Created by 陈行 on 16/10/28.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "RootViewController.h"
#import "BookChapter.h"
#import "Book.h"

@interface BookReadViewController : RootViewController

@property(nonatomic,strong)Book * book;

@property(nonatomic,strong)NSMutableArray<BookChapter *> * dataArray;
/**
 *  section代表章节，row代表章节的第几行
 */
@property(nonatomic,strong)NSIndexPath * readIndexPath;

@end
