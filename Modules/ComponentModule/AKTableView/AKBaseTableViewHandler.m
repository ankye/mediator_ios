//
//  XTTableViewRootHandler.m
//  XTMultipleTables
//
//  Created by TuTu on 15/12/7.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AKBaseTableViewHandler.h"

@interface AKBaseTableViewHandler () <UITableViewDataSource,UITableViewDelegate,AKBaseTableViewDelegate>

@end

@implementation AKBaseTableViewHandler

#pragma mark - prop
- (dispatch_queue_t)myQueue
{
    if (!_myQueue) {
        _myQueue = dispatch_queue_create("mySyncQueue", DISPATCH_QUEUE_CONCURRENT) ;
    }
    return _myQueue ;
}


#pragma mark --
#pragma mark - Public
- (void)handleDatasourceAndDelegate:(AKBaseTableView*)view
{
// set datasource and delegate .
    self.table = view ;

    self.table.btDelegate = self;
    
    self.table.dataSource = self ;
    self.table.delegate = self ;
// needs layout
    [self.table setNeedsLayout] ;
}

- (void)refreshOffsetY
{
    CGPoint offset = self.table.contentOffset ;
    offset.y = self.offsetY ;
    self.table.contentOffset = offset ;
}



- (void)refresh
{
    
}
-(BOOL)hasDataSource
{
    return NO;
}
- (NSString*)getTitle
{
    return @"undefine";
}

- (void)loadNewData
{
    
}
- (void)loadMoreData
{
    
}

- (void)offsetYHasChangedValue:(CGFloat)offsetY
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0. ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell*)getCell:(UITableView*)tableView withName:(NSString*)identifier
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier] ;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    }
    return cell;
}

@end
