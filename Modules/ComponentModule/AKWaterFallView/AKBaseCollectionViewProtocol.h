//
//  AKBaseCollectionViewDelegate.h
//  Project
//
//  Created by ankye on 2017/1/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKBaseCollectionViewProtocol <NSObject>

@optional
- (void)loadNewData ;
- (void)loadMoreData ;

@end
