//
//  HSTB_FlowLayout.m
//  ZKHorizontalScrollToolBar
//
//  Created by 郑凯 on 2016/11/30.
//  Copyright © 2016年 tzktzk1. All rights reserved.
//

#import "AKHScrollFlowLayout.h"

@implementation AKHScrollFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    
    if (self.collectionView.bounds.size.height) {
        self.itemSize = self.collectionView.bounds.size;
    }
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end


