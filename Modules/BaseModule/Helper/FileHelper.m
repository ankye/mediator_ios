//
//  FileHelper.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

//通过plist名称获得数组
+(NSArray*)getArrayFromPlist:(NSString*)name
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"plist"]];
    
}

+ (YYWebImageManager *)avatarImageManager {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"ak.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:100]; // a large value
        };
    });
    return manager;
}

@end
