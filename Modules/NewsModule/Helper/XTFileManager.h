//
//  MyFileManager.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTFileManager : NSObject

//创建文件夹
+ (void)createFileBoxesWithPath:(NSString *)pathStr;

//判断文件名存在吗
+ (BOOL)is_file_exist:(NSString *)path;

//单个文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

//删除文件
+ (BOOL)deleteFileWithFileName:(NSString *)fileName;
//NSKeyedArchiver
//归档obj
+ (void)archiveTheObject:(id)obj AndPath:(NSString *)path;

//解归档
+ (id)getObjUnarchivePath:(NSString *)path;

//保存图片
+ (void)savingPicture:(UIImage *)picture path:(NSString *)path ;

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath;
// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath;


// 方法1：循环调用fileSizeAtPath1
+ (long long) folderSizeAtPath1:(NSString*) folderPath;
// 方法2：循环调用fileSizeAtPath2
+ (long long) folderSizeAtPath2:(NSString*) folderPath;
// 方法2：在folderSizeAtPath2基础之上，去除文件路径相关的字符串拼接工作
+ (long long) folderSizeAtPath3:(NSString*) folderPath;

@end
