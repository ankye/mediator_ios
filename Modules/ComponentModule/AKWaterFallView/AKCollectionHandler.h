//
//  AKCollectionViewHandler.h
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKView.h"
#import "AKDataHandlerProtocol.h"

@interface AKCollectionHandler : NSObject <AKDataHandlerProtocol>

@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .
@property (nonatomic,strong) UICollectionView    *table ;

- (void)handleDatasourceAndDelegate:(UIView*)view ;

- (void)refreshOffsetY ;
- (void)refresh ;

- (NSString*)getTitle;
@end
