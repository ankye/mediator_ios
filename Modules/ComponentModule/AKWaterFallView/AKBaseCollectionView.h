//
//  AKBaseCollectionView.h
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKMJRefreshHeader.h"
#import "AKMJRefreshFooter.h"
#import "AKBaseCollectionViewProtocol.h"




@interface AKBaseCollectionView : UICollectionView


// SET myDelegate TO YOUR CTRLLER
@property (nonatomic,weak) id <AKBaseCollectionViewProtocol> btDelegate ;
// DEFAULT IS `NO`  -> ONLY GIF IMAGES , SHOW WORDS WHEN IT BECOMES `YES`
@property (nonatomic) BOOL showRefreshDetail ;
// DEFAULT IS `NO`  -> MANUALLY LOADING . AUTOMATICALLY LOAD WHEN IT BECOMES `YES`
@property (nonatomic) BOOL automaticallyLoadMore ;
// DEFAULT IS `YES` -> EVERYTIME INITIAL WITH AUTO LOAD NEW . CHANGE IT TO `NO` IF NECESSARY .
@property (nonatomic) BOOL automaticallyLoadNew ;

- (void)pullDownRefreshHeader ;

-(MJRefreshHeader*)customHeader;
-(MJRefreshFooter*)customFooter;

-(void)refreshData;

@end
