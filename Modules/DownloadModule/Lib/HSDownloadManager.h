//
//  HSDownloadManager.h
//  HappyCampus
//
//  Created by chuanshuangzhang on 16/2/22.
//  Copyright © 2016年 zhoudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDownloadTask.h"


@interface HSDownloadManager : NSObject

+ (id)sharedInstance;

/**
 *  添加任务到任务列表
 *
 *  @param urlString 下载地址
 *  @param group     文件分类（可以为空）
 *
 *  @return 下载任务
 */
-(HSDownloadTask *)addTask:(NSString *)urlString group:(NSString *)group;
/**
 *  根据下载地址获取任务状态
 *
 *  @param urlString 下载地址
 *  @param group     数据分类
 *
 *  @return 下载状态
 */
- (HSDownloadState)getTaskState:(NSString *)urlString group:(NSString *)group;
/**
 *  获取下载进度
 *
 *  @param url   下载地址
 *  @param group 数据分类
 *
 *  @return 进度
 */
- (CGFloat)getProgress:(NSString *)url group:(NSString *)group;
/**
 *  开始任务
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)start:(NSString *)url group:(NSString *)group;
/**
 *  暂停任务
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)pause:(NSString *)url group:(NSString *)group;
/**
 *  删除数据
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)deleteFile:(NSString *)url group:(NSString *)group;

@end
