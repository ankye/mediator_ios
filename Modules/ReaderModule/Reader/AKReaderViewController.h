//
//  ViewController.h
//  ReadEngine
//
//  Created by XuPeng on 16/9/2.
//  Copyright © 2016年 XP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "Book.h"
#import "BookChapter.h"
#import "YMenuViewController.h"

@interface AKReaderViewController : RootViewController

@property(nonatomic,strong)Book * book;

/**
 *  section代表章节，row代表章节的第几行
 */


@property (strong, nonatomic) YMenuViewController *menuView;

@end

