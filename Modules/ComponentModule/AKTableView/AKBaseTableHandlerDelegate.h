//
//  AKTableHandlerProtocol.h
//  Project
//
//  Created by ankye on 2017/1/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKBaseTableHandlerDelegate <NSObject>

//Y轴滚动偏移
- (void)tableDidScrollWithOffsetY:(float)offsetY ;
//Y轴结束拖动
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity;
//刷新
- (void)handlerRefreshing:(id)handler ;
//选择某一行
- (void)didSelectSection:(NSInteger)section withRow:(NSInteger)row withContent:(NSObject* )content ;



@end
