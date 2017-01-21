//
//  AKDownloadManager.h
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKDownloadManager : NSObject

@property (nonatomic,strong) YYThreadSafeArray* downloadList;

SINGLETON_INTR(AKDownloadManager)

-(BOOL)isEmptyList;

@end
