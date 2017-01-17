//
//  AKCustomCollectionViewHandler.h
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCollectionHandler.h"
@class XHSHomeModel;

@protocol AKCustomCollectionHandlerDelegate <NSObject>

- (void)tableDidScrollWithOffsetY:(float)offsetY ;
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity;
- (void)handlerRefreshing:(id)handler ;
- (void)didSelectRow:(UICollectionViewCell*)cell withContent:(XHSHomeModel *)content ;
- (void)bannerSelected:(XHSHomeModel *)content ;

@end


@interface AKCustomCollectionHandler : AKCollectionHandler

@property (nonatomic,weak) id <AKCustomCollectionHandlerDelegate> handlerDelegate ;
@property (nonatomic,strong) AKNewsChannel *channel ;

- (instancetype)initWithChannel:(AKNewsChannel *)channel ;
- (BOOL)hasDataSource ;

@end


