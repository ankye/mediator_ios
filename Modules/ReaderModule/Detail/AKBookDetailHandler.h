//
//  AKBookDetailHandler.h
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKBaseTableViewHandler.h"
#import "Book.h"
#import "BookChapter.h"

@interface AKBookDetailHandler : AKBaseTableViewHandler

@property(nonatomic,strong)Book * book;
@property (nonatomic,strong) NSMutableArray<BookChapter *> *  dataList ;

@end
