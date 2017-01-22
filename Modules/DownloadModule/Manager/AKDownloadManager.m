//
//  AKDownloadManager.m
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDownloadManager.h"
#import "AKDownloadGroupModel.h"
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
     
        AKDownloadGroupModel* group = [self createSingleFileGroup:@"Movie" downloadDir:@"" withTaskName:dic[@"name"] withIcon: dic[@"imgName"] withDesc:dic[@"desc"] withDownloadUrl:dic[@"downLoadUrl"] withFilename:@""];
        
        [self.downloadList addObject:group];
    }
}

-(BOOL)isEmptyList
{
    return self.downloadList.count > 0;
}


-(AKDownloadModel*)createTask:(NSString*)groupName withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename
{
    AKDownloadModel *model = [[AKDownloadModel alloc]init];
    model.taskName = taskName;
    model.icon = icon;
    model.desc = desc;
    model.downLoadUrl = downloadUrl;
    model.filename = filename;
    model.progress = [[HSDownloadManager sharedInstance] getProgress:model.downLoadUrl group:groupName];
    model.task = [[HSDownloadManager sharedInstance] addTask:model.downLoadUrl group:groupName];
    return model;
}


-(AKDownloadGroupModel*)createTaskGroup:(NSString*)groupName downloadDir:(NSString*)dir withTasks:(NSMutableArray<AKDownloadModel*>*)tasks start:(NSInteger)start end:(NSInteger)end current:(NSInteger)current
{
    AKDownloadGroupModel* group = [[AKDownloadGroupModel alloc] init];
    group.groupName = groupName;
    group.tasks = [tasks mutableCopy];
    group.currentTaskIndex = current;
    group.startIndex = start;
    group.endIndex = end;
    if(start == end){
        group.groupProgress = 1.0;
    }else{
        group.groupProgress = (current - start)/ (end - start);
    }
    group.groupDir = dir;
    return group;
}

-(AKDownloadGroupModel*)createSingleFileGroup:(NSString*)groupName downloadDir:(NSString*)dir withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename
{
    NSMutableArray* tasks = [[NSMutableArray alloc] init];
    AKDownloadModel* model = [self createTask:groupName withTaskName:taskName withIcon:icon withDesc:desc withDownloadUrl:downloadUrl withFilename:filename];
    [tasks addObject:model];
    
    AKDownloadGroupModel* group = [self createTaskGroup:groupName downloadDir:dir withTasks:tasks start:0 end:0 current:0];
    return group;
    
}

@end
