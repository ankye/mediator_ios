//
//  MusicModel.h
//  test
//
//  Created by chuanshuangzhang chuan shuang on 16/2/23.
//  Copyright © 2016年 chuanshuangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDownloadTask.h"



@interface AKDownloadModel : NSObject

//@property (nonatomic , strong) NSString *groupName;
//任务名称
@property (nonatomic , strong) NSString *taskName;
//图标
@property (nonatomic , strong) NSString *icon;
//描述
@property (nonatomic , strong) NSString *desc;
//下载路径
@property (nonatomic , strong) NSString *downLoadUrl;
//存放文件名
@property (nonatomic , strong) NSString *filename;
//下载进度
@property (nonatomic , assign) CGFloat progress;
//下载任务
@property (nonatomic,weak) HSDownloadTask *task;

@end
