//
//  DownloadGroupModel.h
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKDownloadModel.h"
#import "HSDownloadTask.h"

@interface AKDownloadGroupModel : NSObject

//组名
@property (nonatomic,strong) NSString* groupName;

//组下载文件夹路径

//下载任务列表
@property (nonatomic,strong) NSMutableArray<AKDownloadModel*>* tasks;
//当前任务索引
@property (nonatomic,assign) NSInteger currentTaskIndex;
//起始任务索引
@property (nonatomic,assign) NSInteger startIndex;
//结束任务索引
@property (nonatomic,assign) NSInteger endIndex;

//支持单点续传
@property (nonatomic,assign) BOOL enableBreakpointResume;

@property (nonatomic,weak) HSDownloadTask *task;

//任务组进度
@property (nonatomic , assign,readonly) CGFloat groupProgress;

@property (nonatomic,weak) id<HSDownloadTaskDelegate> delegate;

-(AKDownloadModel*)currentModel;
-(AKDownloadModel*)goToNextModel;

-(BOOL)isCompleted;


-(HSDownloadState)state;

-(void)addTaskModel:(AKDownloadModel*)model;


@end
