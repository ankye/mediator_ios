//
//  CmsTableHandler.h
//  pro
//
//  Created by TuTu on 16/8/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "AKTableViewHandler.h"

@class AKNewsChannel, Content ;

// 内容 table datasouce & delegate handler 类 .

@protocol CmsTableHandlerDelegate <NSObject>

- (void)tableDidScrollWithOffsetY:(float)offsetY ;
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity;
- (void)handlerRefreshing:(id)handler ;
- (void)didSelectRowWithContent:(Content *)content ;
- (void)bannerSelected:(Content *)content ;

@end


@interface CmsTableHandler : AKTableViewHandler

@property (nonatomic,weak) id <CmsTableHandlerDelegate> handlerDelegate ;
@property (nonatomic,strong) AKNewsChannel *channel ;

- (instancetype)initWithChannel:(AKNewsChannel *)channel ;
- (BOOL)hasDataSource ;

@end
