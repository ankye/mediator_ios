//
//  MainTableView.h
//  quread
//
//  Created by 陈行 on 16/10/31.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UITableView+Category.h"

@interface MainTableView : UITableView

- (void)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

- (void)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
