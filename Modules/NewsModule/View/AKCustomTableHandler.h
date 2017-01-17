//
//  CmsTableHandler.h
//  pro
//
//  Created by TuTu on 16/8/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "AKBaseTableViewHandler.h"
#import "AKBaseTableHandlerDelegate.h"

@class AKNewsChannel ;


@interface AKCustomTableHandler : AKBaseTableViewHandler


@property (nonatomic,strong) AKNewsChannel *channel ;

- (instancetype)initWithChannel:(AKNewsChannel *)channel ;
- (BOOL)hasDataSource ;

@end
