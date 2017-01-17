//
//  MainCollectionView.m
//  quread
//
//  Created by 陈行 on 16/10/31.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "MainCollectionView.h"

@implementation MainCollectionView

- (void)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
}

- (void)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
}
@end
