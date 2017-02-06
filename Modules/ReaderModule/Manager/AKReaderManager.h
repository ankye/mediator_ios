//
//  AKReaderManager.h
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKReaderManager : NSObject

@property (nonatomic,strong) NSMutableDictionary* books;


@property(nonatomic,assign)NSInteger networkStatus;

@property (nonatomic, assign) double systemBattery;

+ (NSInteger)networkStatus;


SINGLETON_INTR(AKReaderManager)


-(void)moduleInitConfigure;


@end
