//
//  DownloadGroupModel.h
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKDownloadModel.h"

@interface AKDownloadGroupModel : NSObject

//组名
@property (nonatomic,strong) NSString* groupName;

//组下载文件夹路径
@property (nonatomic,strong) NSString* groupDir;
//下载任务列表
@property (nonatomic,strong) NSMutableArray<AKDownloadModel*>* tasks;
//当前任务索引
@property (nonatomic,assign) NSInteger currentTaskIndex;
//起始任务索引
@property (nonatomic,assign) NSInteger startIndex;
//结束任务索引
@property (nonatomic,assign) NSInteger endIndex;


//任务组进度
@property (nonatomic , assign) CGFloat groupProgress;


-(AKDownloadModel*)currentModel;

@end
