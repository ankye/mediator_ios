//
//  AKMJRefreshHeader.h
//  Project
//
//  Created by ankye on 2017/1/9.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#define TABLE_HEADER_IMAGES             @"xy_loading_"
#define TABLE_HEADER_IMAGES_COUNT       32


@interface AKMJRefreshHeader : MJRefreshGifHeader

@property (nonatomic,strong) NSArray *gifImageList ;

@end
