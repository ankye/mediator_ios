//
//  AKResourceManager.m
//  Project
//
//  Created by ankye on 2016/12/19.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKResourceManager.h"
@interface AKResourceManager()

@property (nonatomic,strong)NSMutableDictionary* imageDic;

@end

@implementation AKResourceManager

-(id)init
{
    if(self=[super init]){
        _imageDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}


SINGLETON_IMPL(AKResourceManager)

-(void)removeUnusedResource
{
    // 由于遍历键值对时候不能做添加和删除操作, 所以把要删除的key放到一个数组中
    NSMutableArray *keyArr = [NSMutableArray array];
    [self.imageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger count = [self retainCount:obj];
        if(count == 2) {// 字典持有 + obj参数持有 = 2
            [keyArr addObject:key];
        }
    }];
    [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageDic removeObjectForKey:obj];
    }];
}

- (NSUInteger)retainCount:(NSObject*)obj {
    return [[obj valueForKey:@"retainCount"] unsignedLongValue];
}


- (void)weak_setObject:(id)anObject forKey:(NSString *)aKey {
    [self.imageDic setObject:makeWeakReference(anObject) forKey:aKey];
}

- (void)weak_setObjectWithDictionary:(NSDictionary *)dic {
    for (NSString *key in dic.allKeys) {
        [self.imageDic setObject:makeWeakReference(dic[key]) forKey:key];
    }
}

- (id)weak_getObjectForKey:(NSString *)key {
    return weakReferenceNonretainedObjectValue(self.imageDic[key]);
}

@end
