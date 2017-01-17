//
//  NSFileManager+FileCategory.h
//  biyanzhi
//
//  Created by 陈行 on 16-1-19.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (FileCategory)

/**
 *  SDWebImage缓存大小
 *
 *  @return byte
 */
+ (NSInteger)cacheSize;
/**
 *  写入到沙河
 *
 *  @param filePath 文件路径
 *  @param data     数据
 *
 *  @return 成功or失败
 */
+ (BOOL)writeToFile:(NSString *)filePath withData:(NSData *)data;
/**
 *  删除硬盘编辑产生的文章
 *
 *  @return 成功or失败
 */
+ (BOOL)removeEditorImage;
/**
 *  删除webView产生的缓存
 *
 *  @return 成功or失败
 */
+ (BOOL)removeWKWebCache;

/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *
 *  @return 成功or失败
 */
+ (BOOL)removeFilePath:(NSString *)filePath;
/**
 *  文件是否存在
 *
 *  @param filePath 文件位置
 *
 *  @return 成功or失败
 */
+ (BOOL)isExistsFileWithFilePath:(NSString *)filePath;

@end
