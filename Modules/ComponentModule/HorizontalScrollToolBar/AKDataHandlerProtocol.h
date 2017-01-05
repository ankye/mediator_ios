//
//  AKDataHandler.h
//  Project
//
//  Created by ankye on 2017/1/5.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKDataViewProtocol.h"


@protocol AKDataHandlerProtocol <NSObject>

@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .

- (void)handleDatasourceAndDelegate:(id<AKDataViewProtocol>)view ;

- (void)refreshOffsetY ;
- (void)refresh ;

- (BOOL)hasDataSource;

- (NSString*)getTitle;

@end
