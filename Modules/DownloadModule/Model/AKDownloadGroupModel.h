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

@class AKDownloadGroupModel;



@interface AKDownloadGroupModel : NSObject

//组名
@property (nonatomic,strong) NSString* groupName;

//组下载文件夹路径

//下载任务列表
@property (nonatomic,strong) NSMutableArray<AKDownloadModel*>* tasks;
//当前任务索引
@property (nonatomic,assign) NSInteger currentTaskIndex;

//支持断点续传
@property (nonatomic,assign) BOOL enableBreakpointResume;
//续传专用
@property (nonatomic,weak) HSDownloadTask *task;
//当前状态,非断点续传使用
@property (nonatomic,assign) HSDownloadState groupState;

@property (nonatomic,assign) BOOL needStore;
//任务组进度
@property (nonatomic , assign,readonly) CGFloat groupProgress;


@property (nonatomic, readwrite) UBSignal<DictionarySignal> *onDownloadProgress;
@property (nonatomic, readwrite) UBSignal<DictionarySignal> *onDownloadCompleted;
@property (nonatomic, readwrite) UBSignal<DictionarySignal> *onDownloadItemCompleted;

-(AKDownloadModel*)currentModel;
-(AKDownloadModel*)goToNextModel;

//-(BOOL)isCompleted;

-(CGFloat)calcProgress;



-(void)addTaskModel:(AKDownloadModel*)model;
//数据加载完成重置
-(void)resetSignals;

@end
