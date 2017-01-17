//
//  RootTableView.h
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKBaseTableViewDelegate.h"
#import "AKBaseTableHandlerDelegate.h"
#import "MJRefresh.h"




@interface AKBaseTableView : UITableView

// table协议
@property (nonatomic,weak) id <AKBaseTableViewDelegate> btDelegate ;

//默认为NO，显示刷新详情（YES)
@property (nonatomic) BOOL showRefreshDetail ;
//自动加载更多,默认NO
@property (nonatomic) BOOL automaticallyLoadMore ;
//自动加载新数据,默认YES
@property (nonatomic) BOOL automaticallyLoadNew ;

//下拉刷新头部
- (void)pullDownRefreshHeader ;


-(MJRefreshHeader*)customHeader;
-(MJRefreshFooter*)customFooter;

@end
