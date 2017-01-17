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
#import "AJWaveRefreshAutoStateFooter.h"
#import "AJWaveRefreshHeader.h"

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
    [self addObserver:self
           forKeyPath:@"contentOffset"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:nil] ;
    
    [self MJRefreshConfigure] ;
    
}

- (void)MJRefreshConfigure
{
    
    self.mj_header = [self customHeader];
    self.mj_footer = [self customFooter];
    
    self.showRefreshDetail = YES ;
    self.automaticallyLoadMore = NO ;
    self.automaticallyLoadNew = YES ;

}

-(MJRefreshHeader*)customHeader
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSelector)];
    return header;
}

-(MJRefreshFooter*)customFooter
{
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSelector)];
    return footer;
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
    if (self.btDelegate && [self.btDelegate respondsToSelector:@selector(loadNewData)]) {
        [self.btDelegate loadNewData] ;
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
            if (self.btDelegate && [self.btDelegate respondsToSelector:@selector(loadMoreData)]) {
                [self.btDelegate loadMoreData] ;
            }
            [self footerEnding] ;
        }) ;
        
        return ;
    }
    else
    {
        if (self.btDelegate && [self.btDelegate respondsToSelector:@selector(loadMoreData)]) {
            [self.btDelegate loadMoreData] ;
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

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"contentOffset"
                 context:nil] ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self) {
        //        NSLog(@"change %@",change) ;
        id old = change[NSKeyValueChangeOldKey] ;
        id new = change[NSKeyValueChangeNewKey] ;
        if (![old isKindOfClass:[NSNull class]] && old != new) {
            CGFloat contentOffsetY = self.contentOffset.y ;
            if(self.btDelegate && [self.btDelegate respondsToSelector:@selector(offsetYHasChangedValue:)]){
                [self.btDelegate offsetYHasChangedValue:contentOffsetY];
            }
           
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context] ;
    }
}


@end
