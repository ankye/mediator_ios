//
//  RootTableView.m
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AKBaseTableView.h"
#import "AKMJRefreshHeader.h"
#import "AKMJRefreshFooter.h"

@implementation AKBaseTableView
#pragma mark --
#pragma mark - Public
- (void)pullDownRefreshHeader
{
    [self.mj_header beginRefreshing] ;
}

#pragma mark --
#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style] ;
    if (self) {
        [self setup] ;
    }
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup] ;
    }
    return self;
}

- (void)setup
{
    [self MJRefreshConfigure] ;
    [self defaultPublicAPIs] ;
}

- (void)MJRefreshConfigure
{
 
    
    AKMJRefreshHeader *header = [AKMJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)];
    self.mj_header = header;
    
    AKMJRefreshFooter *footer = [AKMJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSelector)];
   
    self.mj_footer = footer;
}

- (void)defaultPublicAPIs
{
    self.showRefreshDetail = NO ;
    self.automaticallyLoadMore = NO ;
    self.automaticallyLoadNew = YES ;
}

#pragma mark --
#pragma mark - Public Properties
- (void)setShowRefreshDetail:(BOOL)showRefreshDetail
{
    _showRefreshDetail = showRefreshDetail ;
    
    ((MJRefreshGifHeader *)self.mj_header).lastUpdatedTimeLabel.hidden = !self.showRefreshDetail;
    ((MJRefreshGifHeader *)self.mj_header).stateLabel.hidden = !self.showRefreshDetail ;
    ((MJRefreshBackGifFooter *)self.mj_footer).stateLabel.hidden = !self.showRefreshDetail ;
}

- (void)setAutomaticallyLoadMore:(BOOL)automaticallyLoadMore
{
    _automaticallyLoadMore = automaticallyLoadMore ;
    
    if (_automaticallyLoadMore)
    {
        self.mj_footer = nil ;
        MJRefreshAutoFooter *autofooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(loadMoreDataSelector)] ;
        autofooter.triggerAutomaticallyRefreshPercent = 0.55 ;
        self.mj_footer = autofooter;
    }
}

- (void)setAutomaticallyLoadNew:(BOOL)automaticallyLoadNew
{
    _automaticallyLoadNew = automaticallyLoadNew ;
    
    if (_automaticallyLoadNew) {
        [self.mj_header beginRefreshing] ;
    } else {
        [self.mj_header endRefreshing] ;
    }
}



#pragma mark --
#pragma mark - loading methods

- (void)loadNewDataSelector
{
    if (self.xt_Delegate && [self.xt_Delegate respondsToSelector:@selector(loadNewData)]) {
        [self.xt_Delegate loadNewData] ;
    }
    
    [self headerEnding] ;
}

- (void)headerEnding
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reloadData];
        [self.mj_header endRefreshing];
    }) ;
}

- (void)loadMoreDataSelector
{
    if (_automaticallyLoadMore)
    {
        dispatch_queue_t queue = dispatch_queue_create("refreshAutoFooter", NULL) ;
        dispatch_async(queue, ^{
            if (self.xt_Delegate && [self.xt_Delegate respondsToSelector:@selector(loadMoreData)]) {
                [self.xt_Delegate loadMoreData] ;
            }
            [self footerEnding] ;
        }) ;
        
        return ;
    }
    else
    {
        if (self.xt_Delegate && [self.xt_Delegate respondsToSelector:@selector(loadMoreData)]) {
            [self.xt_Delegate loadMoreData] ;
        }
    }
    
    [self footerEnding] ;
}

- (void)footerEnding
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reloadData];
        [self.mj_footer endRefreshing];
    }) ;
}


@end