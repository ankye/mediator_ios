//
//  NSFileManager+FileCategory.m
//  biyanzhi
//
//  Created by 陈行 on 16-1-19.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "NSFileManager+FileCategory.h"
#import "NSUserDefaults+Category.h"
#import "UIImageView+WebCache.h"

#define SDWEBIMAGE_PATH [NSString stringWithFormat:@"%@/Library/Caches/default/com.hackemist.SDWebImageCache.default",NSHomeDirectory()]

#define EDITOR_IMAGE_PATH [NSString stringWithFormat:@"%@/Library/Caches/editor",NSHomeDirectory()]

#define WKWEBVIEW_CACHE [NSString stringWithFormat:@"%@/Library/Caches/WebKit",NSHomeDirectory()]

@implementation NSFileManager (FileCategory)



/**
 *  获取SDWebImage缓存大小
 *
 *  @return 缓存大小
 */
+ (NSInteger)cacheSize{
    //    NSDate * date=[NSDate date];//起始时间
    NSFileManager * fm=[NSFileManager defaultManager];
    NSInteger fileSize=0;
    NSString * path=SDWEBIMAGE_PATH;
    for (NSString * fileName in [fm subpathsAtPath:path]) {
        NSError * error;
        NSDictionary * dict=[fm attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:&error];
        
        fileSize+=error?0:[dict fileSize];
    }
    path = WKWEBVIEW_CACHE;
    
    for (NSString * fileName in [fm subpathsAtPath:path]) {
        NSError * error;
        NSDictionary * dict=[fm attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:&error];
        
        fileSize+=error?0:[dict fileSize];
    }
    //    NSTimeInterval time=[date timeIntervalSinceNow];//结束时间
    //    NSLog(@"size%f-->%f",fileSize*1.0/1024/1024,time);//打印日志
    return fileSize;
}

+ (BOOL)writeToFile:(NSString *)filePath withData:(NSData *)data{
    NSFileManager * fm=[NSFileManager defaultManager];
    NSArray * array = [filePath componentsSeparatedByString:@"/"];
    NSString * directoryPath = [[filePath componentsSeparatedByString:[array lastObject]] firstObject];
    if(![fm fileExistsAtPath:filePath]){
        [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL res =[data writeToFile:filePath atomically:YES];
    if (!res) {
        NSLog(@"---->写入失败");
    }
    return res;
}

+ (BOOL)removeEditorImage{
    [[SDImageCache sharedImageCache]clearMemory];
    return [self removeFilePath:EDITOR_IMAGE_PATH];
}

+ (BOOL)removeWKWebCache{
    return [self removeFilePath:WKWEBVIEW_CACHE];
}

+ (BOOL)removeFilePath:(NSString *)filePath{
    NSFileManager * fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:filePath error:nil];
}

+ (BOOL)isExistsFileWithFilePath:(NSString *)filePath{
    NSFileManager * fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

@end
