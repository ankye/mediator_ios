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

/**
 获取FMDB的数据库路径
 
 @param dbname 数据库名字
 @return 路径
 */
+(NSString*)getFMDBPath:(NSString*)dbname
{

    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.db",dbname]];
    return filePath;
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



/**
 取得系统位置

 @return 字符串
 */
+ (NSString *)SystemPath
{
    NSString *documentsDirectory;
#if TARGET_IPHONE_SIMULATOR
    // 模拟器环境 DB保存路径
    documentsDirectory = @"/Users/Shared";
    
#else
    // 真机环境 DB保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
#endif
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        // 创建文件夹路径
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}


/**
 取得登陆用户位置

 @param idex 用户id
 @return 路径
 */
+ (NSString *)getUserInfoPath:(NSString *)idex
{
    NSString *userDir = [[self SystemPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", idex]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:userDir]) {
        // 创建文件夹路径
        [[NSFileManager defaultManager] createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userDir;
    
}


@end
