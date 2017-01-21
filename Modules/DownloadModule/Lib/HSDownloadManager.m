//
//  HSDownloadManager.m
//  HappyCampus
//
//  Created by chuanshuangzhang on 16/2/22.
//  Copyright © 2016年 zhoudong. All rights reserved.
//

#import "HSDownloadManager.h"

#define  DownLoadTask @"DownLoadTask"

@interface HSDownloadManager ()<HSDownloadTaskDelegate>
/*任务信息*/
@property (nonatomic, strong) NSMutableDictionary *downloadTasks;
/*所有下载的数据状态*/
@property (nonatomic, strong) NSMutableArray *downloadArray;

@end

@implementation HSDownloadManager

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static HSDownloadManager *downloadManager;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    return downloadManager;
}

- (NSMutableDictionary *)downloadTasks
{
   if(_downloadTasks == nil)
   {
       _downloadTasks = [NSMutableDictionary dictionary];
   }
    return _downloadTasks;
}

- (NSMutableArray *)downloadArray
{
   if(_downloadArray == nil)
   {
       _downloadArray = [NSMutableArray array];
   }
    return _downloadArray;
}

- (HSDownloadTask *)addTask:(NSString *)urlString group:(NSString *)group
{
    HSDownloadTask *task = [self getDownLoadTask:urlString];
    if(task == nil)
    {
        task = [[HSDownloadTask alloc]init];
        self.downloadTasks[urlString] = task;
        task.sessionModel.urlString = urlString;
        task.sessionModel.fileGroup = group;
        task.state = [self getTaskState:urlString group:group];
        task.delegate = self;
        [self saveDownLoadTask];
    }
    return task;
}
/**
 *  根据下载地址获取任务状态
 *
 *  @param urlString 下载地址
 *
 *  @return 下载状态
 */
- (HSDownloadState)getTaskState:(NSString *)urlString group:(NSString *)group
{
    // 下载完成
    if ([HSDownloadTask isCompletion:urlString group:group]) {
        return HSDownloadStateCompleted;
    }
    // 查询未完成的任务列表
    NSInteger index = [self isExit:urlString];
    if (index != -1) {
        return HSDownloadStateSuspended;
    }
    return HSDownloadStateNone;
}
/**
 *  获取下载进度
 *
 *  @param url   下载地址
 *  @param group 数据分类
 *
 *  @return 进度
 */
- (CGFloat)getProgress:(NSString *)url group:(NSString *)group
{
    return [HSDownloadTask progress:url group:group];
}
/**
 *  开始任务
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)start:(NSString *)url group:(NSString *)group
{
    HSDownloadTask *task = [self getDownLoadTask:url];
    if(task != nil)
    {
        [task start];
    }
}
/**
 *  暂停任务
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)pause:(NSString *)url group:(NSString *)group
{
    HSDownloadTask *downLoadTask = [self getDownLoadTask:url];
    if(downLoadTask)
    {
        [downLoadTask pause];
    }
}
/**
 *  删除数据
 *
 *  @param url   下载地址
 *  @param group 分类
 */
- (void)deleteFile:(NSString *)url group:(NSString *)group
{
    HSDownloadTask *downLoadTask = [self getDownLoadTask:url];
    if(downLoadTask == nil)
    {
        downLoadTask = [[HSDownloadTask alloc]init];
    }
    [downLoadTask deleteFile:url group:group];
    [self.downloadTasks removeObjectForKey:url];
    [self deleteFile:url group:group];

}
-(HSDownloadTask *)getDownLoadTask:(NSString *)urlkey{
    return  [self.downloadTasks objectForKey:urlkey];
}

//　保存本地任务
-(void)saveDownLoadTask{
    NSString *filename = [self filePathWithFileName:DownLoadTask];
    for (NSString *string in self.downloadTasks.allKeys) {
        HSDownloadTask *downLoadTask = [self.downloadTasks objectForKey:string];
        NSMutableDictionary *mpSession = [[NSMutableDictionary alloc ] init];
        [mpSession setObject:string  forKey:@"DownloadUrlString"];
        if(downLoadTask.sessionModel.fileGroup){
          [mpSession setObject:downLoadTask.sessionModel.fileGroup forKey:@"DownloadGroup"];
        }
        NSInteger index = [self isExit:string];
        if (index == -1) {
            [self.downloadArray addObject:mpSession];
        }else{
            [self.downloadArray replaceObjectAtIndex:index withObject:mpSession];
        }
    }
    [self.downloadArray writeToFile:filename atomically:NO];
}

-(NSString *)filePathWithFileName:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    return filename;
}
/**
 *  判断下载任务的状态
 *
 *  @param urlString 下载地址
 *
 *  @return 任务状态
 */
-(NSInteger)isExit:(NSString *)urlString{
    
    for (NSInteger i = 0; i < self.downloadArray.count; i ++) {
        NSDictionary *dic = self.downloadArray[i];
        NSString *url = [dic objectForKey:@"DownloadUrlString"];
        if ([url isEqualToString:urlString]) {
            return i;
        }
    }
    return -1;
}
/**
 *  删除本地
 *
 *  @param url   下载地址
 *  @param group 文件分类
 */
-(void)deleteDownLoadTask:(NSString *)url group:(NSString *)group{
    NSString *filename = [self filePathWithFileName:DownLoadTask];
    NSInteger index = [self isExit:url];
    if (index != -1) {
        [self.downloadArray removeObjectAtIndex:index];
    }
    [self.downloadArray writeToFile:filename atomically:NO];
}

//　读取本地任务
-(NSMutableArray *)loadDownLoadTask{
    NSString *filename = [self filePathWithFileName:DownLoadTask];
    NSMutableArray *dic = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    if (dic == nil) {
        return [[NSMutableArray alloc ] init];
    }
    return dic;
}
#pragma mark task delegate

- (void)downloadComplete:(HSDownloadState)downloadState downLoadUrlString:(NSString *)downLoadUrlString
{
    // 修改本地状态
    [self saveDownLoadTask];
    if (downloadState == HSDownloadStateCompleted) {
        //　删除本地任务
        [self.downloadTasks removeObjectForKey:downLoadUrlString];
    }
}
@end
