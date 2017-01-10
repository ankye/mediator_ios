//
//  AKCollectionViewHandler.m
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCollectionHandler.h"

@interface AKCollectionHandler () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation AKCollectionHandler

#pragma mark --
#pragma mark - Public
- (void)handleDatasourceAndDelegate:(UIView*)view
{
    // set datasource and delegate .
    self.table = (UICollectionView*)view ;
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


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 0;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
