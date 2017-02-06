//
//  AKReaderManager.m
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKReaderManager.h"
#import "NSFileManager+FileCategory.h"
#import "SDWebImageManager.h"
#import "SQLiteManager.h"
#import "AFNetworking.h"
#import "InitialData.h"



@implementation AKReaderManager

SINGLETON_IMPL(AKReaderManager)

-(id)init
{
    self = [super init];
    if(self){
        self.books = [[NSMutableDictionary alloc] init];
    }
    return self;
}



-(void)moduleInitConfigure
{
    //检查数据库版本
    [self checkDatabaseVersion];
    
    //设置图片内存缓存为20M
    [[SDImageCache sharedImageCache] setMaxCacheSize:1024*1024*20];
    
    //开启网络监测
    [self checkNetworkStatus];
    
    //初始化数据
    [self setInitialData];
}


- (void)checkDatabaseVersion{
    [SQLiteManager checkAndUpdateDatabaseVersion];
}

- (void)checkNetworkStatus{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _networkStatus=status;
    }];
}

- (void)setInitialData{
    [InitialData sharedInitialData];
}

+ (NSInteger)networkStatus{
    return [AKReaderManager sharedInstance].networkStatus;
}





@end
