//
//  XTMultipleTables.m
//  XTMultipleTables
//
//  Created by TuTu on 15/12/4.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AKMutableView.h"
#import "XTTableViewRootHandler.h"
#import "CmsTableHandler.h"
#import "AKCustomTableView.h"
#import "UIColor+AllColors.h"

static int IMAGEVIEW_COUNT = 3 ;

@interface AKMutableView () <UIScrollViewDelegate>

@property (nonatomic,strong) UITableView        *leftTable ;
@property (nonatomic,strong) AKCustomTableView  *centerTable ;
@property (nonatomic,strong) UITableView        *rightTable ;

@property (nonatomic,assign) NSInteger          allCount ;
@property (nonatomic,strong) NSMutableArray     *handlerList;


@end

@implementation AKMutableView

#pragma mark - Public
- (void)mutableViewDidMoveAtIndex:(NSInteger)index
{
    _currentIndex = index ;

    [self resetTableHandersList] ;
    [self resetOffsetYOfEveryTable] ;
}

- (void)pulldownCenterTableIfNeeded
{
    CmsTableHandler *handlerCenter = (CmsTableHandler *)_handlerList[_currentIndex] ;
    if ( ![handlerCenter hasDataSource] ) {
        [_centerTable pullDownRefreshHeader] ;
    }
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup] ;
    }
    return self;
}

- (void)setup
{
    [self setupScrollView] ;
    [self setupTables] ;
    [self setupDefaultTable];
}

- (void)setupScrollView
{
    self.delegate = self ;
    self.contentSize = CGSizeMake(IMAGEVIEW_COUNT * self.frame.size.width, self.frame.size.height) ;
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO] ;
    self.pagingEnabled = YES ;
    self.showsHorizontalScrollIndicator = NO ;
    self.bounces = false ;
}

- (void)setupTables
{
    [self leftTable] ;
    [self centerTable] ;
    [self rightTable] ;
    
}

- (void)setupDefaultTable
{
    
    // set default center , left and right if needed .
    if (_handlerList.count > 0) {
        [(XTTableViewRootHandler *)_handlerList[0] handleTableDatasourceAndDelegate:_centerTable] ;
        [(XTTableViewRootHandler *)_handlerList[0] centerHandlerRefreshing] ;
    }
    
    if (self.allCount > 1)
    {
        [(XTTableViewRootHandler *)_handlerList[self.allCount - 1] handleTableDatasourceAndDelegate:_leftTable] ;
        [(XTTableViewRootHandler *)_handlerList[1] handleTableDatasourceAndDelegate:_rightTable] ;
        
        if ([_handlerList[self.allCount - 1] isKindOfClass:[CmsTableHandler class]]) {
            [((CmsTableHandler *)_handlerList[self.allCount - 1]) tableIsFromCenter:false] ;
        }
        if ([_handlerList[1] isKindOfClass:[CmsTableHandler class]]) {
            [((CmsTableHandler *)_handlerList[1]) tableIsFromCenter:false] ;
        }
    }
    
    _currentIndex = 0 ;
}

#pragma mark - Property
- (UITableView *)leftTable
{
    if (!_leftTable) {
        CGRect rectLeft = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
        _leftTable = [[UITableView alloc] initWithFrame:rectLeft style:UITableViewStylePlain] ;
        _leftTable.separatorStyle = 0 ;
        _leftTable.backgroundColor = [UIColor xt_cellSeperate] ;
      
        if (![_leftTable superview]) {
            [self addSubview:_leftTable] ;
        }
    }
    return _leftTable ;
}

- (AKCustomTableView *)centerTable
{
    if (!_centerTable) {
        CGRect rectCenter = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
        rectCenter.origin.x += rectCenter.size.width ;
        _centerTable = [[AKCustomTableView alloc] initWithFrame:rectCenter] ;
//        _centerTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0) ;
     
        if (![_centerTable superview]) {
            [self addSubview:_centerTable] ;
        }
    }
    return _centerTable ;
}

- (UITableView *)rightTable
{
    if (!_rightTable) {
        CGRect rectRight = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
        rectRight.origin.x += (rectRight.size.width * 2) ;
        _rightTable = [[UITableView alloc] initWithFrame:rectRight style:UITableViewStylePlain] ;
        _rightTable.separatorStyle = 0 ;
        _rightTable.backgroundColor = [UIColor xt_cellSeperate] ;
//        _rightTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0) ;

        if (![_rightTable superview]) {
            [self addSubview:_rightTable] ;
        }
    }
    return _rightTable ;
}

- (NSInteger)allCount
{
    if (!_allCount && _handlerList != nil) {
        _allCount = (int)_handlerList.count ;
    }
    return _allCount ;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // cache tableview offset Y.
    ((XTTableViewRootHandler *)_handlerList[_currentIndex]).offsetY = _centerTable.contentOffset.y ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refresh] ;
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO] ;
    [self resetOffsetYOfEveryTable] ;
}

#pragma mark - refresh .
- (void)refresh
{
    CGPoint offset = [self contentOffset] ;
    
//    NSLog(@"offset x : %@",@(offset.x)) ;
    if (offset.x > self.frame.size.width)
    {
    // scroll to left
        _currentIndex = (_currentIndex + 1) % self.allCount ;
    }
    else if(offset.x < self.frame.size.width)
    {
    // scroll to right
        _currentIndex = (_currentIndex + self.allCount - 1) % self.allCount ;
    }
    else
        return ;
    
//    NSLog(@"currentIndex is : %d",_currentIndex) ;
    [self resetTableHandersList] ;
}

- (void)resetTableHandersList
{
    NSInteger leftIndex , rightIndex ;
    // reset handler of center .
    [(XTTableViewRootHandler *)_handlerList[_currentIndex] handleTableDatasourceAndDelegate:_centerTable] ;
    
    
    // reset handler of left and right .
    leftIndex   = (_currentIndex + self.allCount - 1) % self.allCount ;
    rightIndex  = (_currentIndex + 1) % self.allCount ;
    [(XTTableViewRootHandler *)_handlerList[leftIndex] handleTableDatasourceAndDelegate:_leftTable] ;
    [(XTTableViewRootHandler *)_handlerList[rightIndex] handleTableDatasourceAndDelegate:_rightTable] ;
}

- (void)resetOffsetYOfEveryTable
{
    // reset tableview offset Y.
    [((XTTableViewRootHandler *)_handlerList[_currentIndex]) refreshOffsetY] ;
    NSInteger leftIndex   = (_currentIndex + self.allCount - 1) % self.allCount ;
    NSInteger rightIndex  = (_currentIndex + 1) % self.allCount ;
    [(XTTableViewRootHandler *)_handlerList[leftIndex] refreshOffsetY] ;
    [(XTTableViewRootHandler *)_handlerList[rightIndex] refreshOffsetY] ;
    
    // reset center table banner cell 's loop timer to origin .
    [self resetLoopTimer] ;
    
    [self.akDelegate viewDidMovedAtIndex:self atIndex:_currentIndex] ;
    
    [((XTTableViewRootHandler *)_handlerList[_currentIndex]) centerHandlerRefreshing] ;
}

- (void)resetLoopTimer
{
    NSInteger leftIndex   = (_currentIndex + self.allCount - 1) % self.allCount ;
    NSInteger rightIndex  = (_currentIndex + 1) % self.allCount ;
    if ([_handlerList[leftIndex] isKindOfClass:[CmsTableHandler class]]) {
        [((CmsTableHandler *)_handlerList[leftIndex]) tableIsFromCenter:false] ;
    }
    if ([_handlerList[rightIndex] isKindOfClass:[CmsTableHandler class]]) {
        [((CmsTableHandler *)_handlerList[rightIndex]) tableIsFromCenter:false] ;
    }
    
    if ([_handlerList[_currentIndex] isKindOfClass:[CmsTableHandler class]]) {
        [((CmsTableHandler *)_handlerList[_currentIndex]) tableIsFromCenter:true] ;
    }
}

-(void)reloadHandlers:(NSMutableArray*)handlerList
{
    self.handlerList = handlerList;
    self.scrollEnabled = (_handlerList.count > 1) ;
    [self setupDefaultTable];
}
@end
