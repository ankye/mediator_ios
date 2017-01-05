//
//  XTTableViewRootHandler.m
//  XTMultipleTables
//
//  Created by TuTu on 15/12/7.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AKTableViewHandler.h"

@interface AKTableViewHandler () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation AKTableViewHandler

#pragma mark --
#pragma mark - Public
- (void)handleDatasourceAndDelegate:(id<AKDataViewProtocol>)view
{
// set datasource and delegate .
    self.table = (UITableView*)view ;
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
#pragma mark - root table view delegate
- (void)loadNewData
{
    
}

- (void)loadMoreData
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

@end
