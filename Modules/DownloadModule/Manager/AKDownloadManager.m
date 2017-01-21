//
//  AKDownloadManager.m
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDownloadManager.h"
#import "AKDownloadModel.h"
#import "HSDownloadManager.h"

@implementation AKDownloadManager

SINGLETON_IMPL(AKDownloadManager)

- (YYThreadSafeArray *)downloadList
{
    if (!_downloadList) {
        _downloadList = [[YYThreadSafeArray alloc] init] ;
        [self loadCacheList];
        
    }
    return _downloadList ;
    
  
}

-(void)loadCacheList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Discover" ofType:@".plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        AKDownloadModel *model = [[AKDownloadModel alloc]init];
        model.downLoadUrl = dic[@"downLoadUrl"];
        model.desc = dic[@"desc"];
        model.imgName = dic[@"imgName"];
        model.name = dic[@"name"];
        model.group = @"Movie";
        model.progress = [[HSDownloadManager sharedInstance] getProgress:model.downLoadUrl group:model.group];
        model.task = [[HSDownloadManager sharedInstance] addTask:model.downLoadUrl group:model.group];
        [self.downloadList addObject:model];
    }
}

-(BOOL)isEmptyList
{
    return self.downloadList.count > 0;
}

-(void)createTaskGroup:(NSString*)groupName withTasks:(NSMutableArray<AKDownloadModel*>*)tasks
{
    
}

@end
