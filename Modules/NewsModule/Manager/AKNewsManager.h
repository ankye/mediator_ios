//
//  AKNewsManager.h
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKNewsManager : NSObject

SINGLETON_INTR(AKNewsManager)

@property (nonatomic,strong) NSMutableArray* selectedChannels;
@property (nonatomic,strong) NSMutableArray* unSelectedChannels;


@end
