//
//  HSDownloadTask.h
//  HappyCampus
//
//  Created by chuanshuangzhang chuan shuang on 16/2/22.
//  Copyright © 2016年 zhoudong. All rights reserved.
//

#import <UIKit/UIKit.h>


/*缓存主目录*/
#define MPCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]
/*保存文件名*/
#define MPFileName(url) [[url componentsSeparatedByString:@"/"] lastObject]
/*文件的存放路径（caches）*/
#define MPFileFullpath(url,group) [MPCachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",(group.length <=0 ? @"":[NSString stringWithFormat:@"%@/",group]),MPFileName(url)]]
// 文件的已下载长度
#define MPDownloadLength(url,group) [[[NSFileManager defaultManager] attributesOfItemAtPath:MPFileFullpath(url,group) error:nil][NSFileSize] integerValue]
// 存储文件总长度的文件路径（caches）
#define MPTotalLengthFullpath [MPCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

typedef enum {
    HSDownloadStateNone    = 0,
    HSDownloadStateRunning = 1,    /** 下载中 */
    HSDownloadStateSuspended = 2,     /** 下载暂停 */
    HSDownloadStateCompleted = 3,     /** 下载完成 */
    HSDownloadStateFailed  = 4        /** 下载失败 */
}HSDownloadState;


@protocol HSDownloadTaskDelegate <NSObject>

-(void)downloadComplete:(HSDownloadState)downloadState downLoadUrlString:(NSString *)downLoadUrlString;

@end

typedef void(^HSDownloadProgressBlock)(CGFloat progress, CGFloat totalRead, CGFloat totalExpectedToRead);

typedef void(^HSDownloadCompleteBlock)(HSDownloadState downloadState,NSString *downLoadUrlString);

@interface HSSessionModel : NSObject
/*数据流*/
@property (nonatomic,strong) NSOutputStream *stream;
/*下载地址*/
@property (nonatomic,strong) NSString *urlString;
/*数据分类*/
@property (nonatomic,strong) NSString *fileGroup;
/*获得服务器这次请求 返回数据的总长度*/
@property (nonatomic, assign ) u_int64_t  totalLength;

@end

@interface HSDownloadTask : NSObject
/*下载会话*/
@property (nonatomic,strong) NSURLSession *session;
/*下载任务*/
@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;
/*下载状态*/
@property (nonatomic,readwrite) HSDownloadState state;
/*下载相关信息*/
@property (nonatomic,strong) HSSessionModel *sessionModel;
/*接收到数据的回调*/
@property (nonatomic,copy) HSDownloadProgressBlock downloadProgressBlock;
/*下载完成的回调*/
@property (nonatomic,copy) HSDownloadCompleteBlock downloadCompleteBlock;
/*代理*/
@property (nonatomic,weak) id<HSDownloadTaskDelegate> delegate;

/**
 *  开始下载
 */
- (void)start;
/**
 *  暂停下载
 */
- (void)pause;
/**
 *  停止当前下载并删除本地缓存
 *
 *  @param url 下载地址
 */
- (void)deleteFile:(NSString *)url group:(NSString *)group;

/**
 *  判断该文件是否下载完成
 *
 *  @param url   下载地址
 *  @param group 文件分类
 *
 *  @return 是否下载了
 */
+ (BOOL)isCompletion:(NSString *)url group:(NSString *)group;
/**
 *  获取下载进度
 *
 *  @param urlString 下载地址
 *  @param group     文件分类
 *
 *  @return 下载进度
 */
+ (CGFloat)progress:(NSString *)urlString group:(NSString *)group;

@end
