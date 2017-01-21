//
//  HSDownloadTask.m
//  HappyCampus
//
//  Created by chuanshuangzhang chuan shuang on 16/2/22.
//  Copyright © 2016年 zhoudong. All rights reserved.
//

#import "HSDownloadTask.h"

@implementation HSSessionModel

@end

@interface HSDownloadTask ()<NSURLSessionDelegate>

@end

@implementation HSDownloadTask

- (id)init
{
  if(self = [super init])
  {
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
      self.sessionModel = [[HSSessionModel alloc]init];
  }
    return self;
}

/**
 *  开始下载
 */
- (void)start
{
    //1. 判断是否可以下载
    if(![self downloadAviliable])
    {
        return;
    }
    //2. 创建缓存目录
    [self createCacheDirectory];
    
    //3. 判断这个任务是否已经存在
    if (self.sessionTask == nil) {
        // 创建流
        NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:MPFileFullpath(self.sessionModel.urlString,self.sessionModel.fileGroup) append:YES];
        // 创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.sessionModel.urlString]];
        // 设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", MPDownloadLength(self.sessionModel.urlString,self.sessionModel.fileGroup)];
        [request setValue:range forHTTPHeaderField:@"Range"];
        self.sessionTask = [self.session dataTaskWithRequest:request];
        self.sessionModel.stream    = stream;
    }
    self.state = HSDownloadStateRunning;
    [self.sessionTask resume];
}
/**
 *  暂停下载
 */
- (void)pause
{
    if (self.sessionTask) {
        if (self.sessionTask.state == NSURLSessionTaskStateRunning) {
            [self.sessionTask suspend];
        }
    }
    self.state = HSDownloadStateSuspended;
}
- (BOOL)downloadAviliable
{
    BOOL continueDownLoad = YES;
    // 下载完成
    if ([HSDownloadTask isCompletion:self.sessionModel.urlString group:self.sessionModel.fileGroup]) {
        continueDownLoad = NO;
    }
    return continueDownLoad;
}
/**
 *  判断该文件是否下载完成
 */
+ (BOOL)isCompletion:(NSString *)url group:(NSString *)group
{
    if ([HSDownloadTask fileTotalLength:url] && MPDownloadLength(url,group) == [HSDownloadTask fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)progress:(NSString *)urlString group:(NSString *)group
{
  return [self fileTotalLength:urlString] == 0 ? 0.0 : 1.0 * MPDownloadLength(urlString,group) /  [self fileTotalLength:urlString];
}
/**
 *  获取该资源总大小
 */
+ (NSInteger)fileTotalLength:(NSString *)url
{
    return [[NSDictionary dictionaryWithContentsOfFile:MPTotalLengthFullpath][MPFileName(url)] integerValue];
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = MPCachesDirectory;
    if(self.sessionModel.fileGroup.length > 0)
    {
        path = [NSString stringWithFormat:@"%@/%@",path,self.sessionModel.fileGroup];
    }
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}
#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url group:(NSString *)group
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self.sessionTask cancel];
    if ([fileManager fileExistsAtPath:MPFileFullpath(url,group)]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:MPFileFullpath(url,group) error:nil];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:MPTotalLengthFullpath]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:MPTotalLengthFullpath];
            [dict removeObjectForKey:MPFileName(url)];
            [dict writeToFile:MPTotalLengthFullpath atomically:YES];
        }
    }
}
#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 打开流
    [self.sessionModel.stream open];
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + MPDownloadLength(self.sessionModel.urlString,self.sessionModel.fileGroup);
    self.sessionModel.totalLength = totalLength;
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:MPTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[MPFileName(self.sessionModel.urlString)] = @(totalLength);
    [dict writeToFile:MPTotalLengthFullpath atomically:YES];
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 写入数据
    [self.sessionModel.stream write:data.bytes maxLength:data.length];
    // 下载进度
    NSUInteger receivedSize = MPDownloadLength(self.sessionModel.urlString,self.sessionModel.fileGroup);
    NSUInteger expectedSize = self.sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    if (self.downloadProgressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadProgressBlock(progress,receivedSize,expectedSize);
        });
    }
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!self.sessionModel) return;
    if ([HSDownloadTask isCompletion:self.sessionModel.urlString group:self.sessionModel.fileGroup]) {
        // 下载完成
        self.state = HSDownloadStateCompleted;
        if (self.downloadCompleteBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadCompleteBlock(HSDownloadStateCompleted,self.sessionModel.urlString);
            });
        }
        if ([self.delegate respondsToSelector:@selector(downloadComplete:downLoadUrlString:)]) {
            [self.delegate downloadComplete:HSDownloadStateCompleted downLoadUrlString:self.sessionModel.urlString];
        }
        
    } else if (error){
        // 下载失败
        self.state = HSDownloadStateFailed;
        if (self.downloadCompleteBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadCompleteBlock(HSDownloadStateFailed,self.sessionModel.urlString);
            });
        }
    }
    // 关闭流
    [self.sessionModel.stream close];
    self.sessionModel.stream = nil;
}


@end
