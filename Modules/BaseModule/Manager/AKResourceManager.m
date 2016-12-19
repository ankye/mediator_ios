//
//  AKResourceManager.m
//  Project
//
//  Created by ankye on 2016/12/19.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKResourceManager.h"

static NSMutableDictionary  *_imageCacheDic;



@implementation AKResourceManager

+ (void)initialize
{
    _imageCacheDic = [NSMutableDictionary dictionary];
}

+(void)removeUnusedResource
{
    // 由于遍历键值对时候不能做添加和删除操作, 所以把要删除的key放到一个数组中
    NSMutableArray *keyArr = [NSMutableArray array];
    [_imageCacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger count = CFGetRetainCount((__bridge CFTypeRef)obj);

        if(count == 2) {// 字典持有 + obj参数持有 = 2
            [keyArr addObject:key];
        }
    }];
    [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDLogInfo(@"remove Unused image %@",obj);
        [_imageCacheDic removeObjectForKey:obj];
        obj = nil;
    }];
    
}


+(UIImage*)imageNamed:(NSString*)name
{
    UIImage* image = [_imageCacheDic objectForKey:name];
    
    if(image == nil){
      
        image = [YYImage imageNamed:name];
        if(image){
            [_imageCacheDic setObject:image forKey:name];
        }
        
    }
    
    //.xcassets里面的资源尝试获取
    if(image == nil){
        image = [UIImage imageNamed:name];
    }
    return image;
    
}

@end
