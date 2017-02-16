//
//  AKReaderManager.m
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKReaderManager.h"
#import "SDWebImageManager.h"

#import "AFNetworking.h"



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


//
//-(void)moduleInitConfigure
//{
//  
//    //设置图片内存缓存为20M
//    [[SDImageCache sharedImageCache] setMaxCacheSize:1024*1024*20];
//    
//    //开启网络监测
//    
//    //初始化数据
//}
//








@end
