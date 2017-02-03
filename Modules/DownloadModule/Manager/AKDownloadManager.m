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
#import "SGDownloadManager.h"
#import "NSString+Category.h"
#import <UberSignals/UBSignal.h>

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
   
//    
//    for (NSDictionary *dic in array) {
//     
//        AKDownloadGroupModel* group = [self createSingleFileGroup:dic[@"group"] withTaskName:dic[@"name"] withIcon: dic[@"imgName"] withDesc:dic[@"desc"] withDownloadUrl:dic[@"downLoadUrl"] withFilename:@""];
//        
//    }
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
   
    return model;
}


-(AKDownloadGroupModel*)createTaskGroup:(NSString*)groupName withBreakpointResume:(BOOL)breakpointResume
{
    AKDownloadGroupModel* group = [[AKDownloadGroupModel alloc] init];
    group.groupName = groupName;
    group.tasks = [[NSMutableArray alloc] init];
    group.currentTaskIndex = 0;
    group.startIndex = 0;
    group.endIndex = 0;
    group.enableBreakpointResume = breakpointResume;
    group.onDownloadProgress = (UBSignal<DictionarySignal> *)
    [[UBSignal alloc] initWithProtocol:@protocol(DictionarySignal)];
    group.onDownloadCompleted = (UBSignal<DictionarySignal> *)
    [[UBSignal alloc] initWithProtocol:@protocol(DictionarySignal)];
    
    [self.downloadList addObject:group];
    
    return group;
}

-(AKDownloadGroupModel*)getDownloadGroup:(NSString*)groupName
{
    AKDownloadGroupModel* group = nil;
    NSInteger count = [self.downloadList count];
    for(NSInteger i = count-1; i >= 0; i--){
        NSString* tempName = ((AKDownloadGroupModel*)[self.downloadList objectAtIndex:i]).groupName;
        if([tempName isEqualToString:groupName]){
            group =  [self.downloadList objectAtIndex:i];
        }
    }
    return group;
}

-(AKDownloadModel*)getDownloadModel:(NSString*)groupName withUrl:(NSString*)url
{
    AKDownloadGroupModel* group = [self getDownloadGroup:groupName];
    if(group){
        NSInteger count = [group.tasks count];
        for(NSInteger i = count-1; i >= 0 ;i--){
            NSString* tempurl = ((AKDownloadModel*)[group.tasks objectAtIndex:i]).downLoadUrl;
            if([tempurl isEqualToString:url]){
                return (AKDownloadModel*)[group.tasks objectAtIndex:i];
            }
        }
    }
    return nil;
}

-(AKDownloadGroupModel*)createSingleFileGroup:(NSString*)groupName withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename
{
    NSMutableArray* tasks = [[NSMutableArray alloc] init];
    AKDownloadModel* model = [self createTask:groupName withTaskName:taskName withIcon:icon withDesc:desc withDownloadUrl:downloadUrl withFilename:filename];
    [tasks addObject:model];
    
    AKDownloadGroupModel* group = [self createTaskGroup:groupName withBreakpointResume:YES];
    
    [group addTaskModel:model];
    
    
    return group;
    
}

-(HSDownloadTask*)checkTask:(AKDownloadGroupModel*)group withUrl:(NSString*)url
{
    if(group.task && [group.task.sessionModel.urlString isEqualToString:url] == NO){
        group.task = nil;
    }
    if(group.task == nil){
        group.task = [[HSDownloadManager sharedInstance] addTask:[group currentModel].downLoadUrl group:group.groupName];
        group.task.delegate = self;
    }
    return group.task;
}

-(void)startGroup:(AKDownloadGroupModel*)group
{
    AKDownloadModel* model = [group currentModel];
    NSLog(@"%@ 开始",model.taskName );
   
    if(group.enableBreakpointResume){
        if(model && [model isCompleted]){
            NSLog(@"%@ 断点续传下载已完成",model.taskName );
            
            model = [group goToNextModel];
            if(model){
                [self startGroup:group];
            }
            return;
        }
        
        [self checkTask:group withUrl:model.downLoadUrl];
    
        [[HSDownloadManager sharedInstance] start: model.downLoadUrl group: group.groupName];
    }else{
        if(model && [self isDownloadCompleted:group.groupName withUrl:model.downLoadUrl]){
            NSLog(@"%@ 普通下载已完成",model.taskName );
            
            model = [group goToNextModel];
            if(model){
                [self startGroup:group];
            }
            return ;
        }
        group.groupState = HSDownloadStateRunning;
        
        @weakify(self);
        [[SGDownloadManager shareManager] downloadWithURL:AKURL(model.downLoadUrl) progress:^(NSInteger completeSize, NSInteger expectSize) {
            @strongify(self);
            [self downloadProgress:group.groupName withUrl:model.downLoadUrl withProgress:group.groupProgress withTotalRead:completeSize withTotalExpected:expectSize];
            
        } complete:^(NSDictionary *respose, NSError *error) {
            @strongify(self);
            
            NSString* path = [self getDownloadFilePath:group.groupName withUrl:model.downLoadUrl];
            if([respose[@"isFinished"] boolValue]){
                [[NSFileManager defaultManager] moveItemAtPath:respose[@"filePath"] toPath:path error:nil];
            }else{
                [self removeDownloadFile:group.groupName withUrl:model.downLoadUrl];
            }
            [self downloadComplete:HSDownloadStateCompleted withGroupName:group.groupName downLoadUrlString:model.downLoadUrl];
            
        }];
    }
    
}

-(NSString*)getDownloadGroupDir:(NSString*)group
{
    NSString *path = MPCachesDirectory;
    if(group.length > 0)
    {
        path = [NSString stringWithFormat:@"%@/%@",path,group];
    }
    return path;
}

-(void)checkGroupDir:(NSString*)group
{
    NSString* path = [self getDownloadGroupDir:group];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
}


-(void)removeDownloadFile:(NSString*)group withUrl:(NSString*)url
{
    NSString* path = [self getDownloadFilePath:group withUrl:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    
}
-(NSString*)getDownloadFilePath:(NSString*)group withUrl:(NSString*)url
{
    [self checkGroupDir:group];
    NSString *path = [self getDownloadGroupDir:group];
    path =  [NSString stringWithFormat:@"%@/%@",path,[url md5]];
    
    return path;
}

-(BOOL) isDownloadCompleted:(NSString*)group withUrl:(NSString*)url
{
    NSString* path = [self getDownloadFilePath:group withUrl:url];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        return YES;
    }else{
        return NO;
    }
}

-(void)startGroup:(AKDownloadGroupModel*)group atIndex:(NSInteger)index;
{
    if(index > group.endIndex || index < group.startIndex){
        return;
    }
    [self pauseGroup:group];
    
    group.currentTaskIndex = index;
    
    [self startGroup:group];
}


-(void)pauseGroup:(AKDownloadGroupModel*)group
{
    if([group isCompleted]){
        return;
    }
    AKDownloadModel* model = [group currentModel];
    if(group.enableBreakpointResume){
        [[HSDownloadManager sharedInstance] pause:model.downLoadUrl group:group.groupName];
    }else{
        group.groupState = HSDownloadStateSuspended;
        [[SGDownloadManager shareManager] supendDownloadWithUrl:model.downLoadUrl];
    }
    
}

-(void)deleteGroup:(AKDownloadGroupModel*)group
{
    
}



-(void)downloadProgress:(NSString*)groupName withUrl:(NSString*)url withProgress:(CGFloat)progress withTotalRead:(CGFloat)totalRead withTotalExpected:(CGFloat)expected
{
    AKDownloadGroupModel* group = [self getDownloadGroup:groupName];
    [group currentModel].progress = progress;

  group.onDownloadProgress.fire(@{@"groupName":groupName,@"url":url,@"progress":@(progress),@"totalRead":@(totalRead),@"expected":@(expected)});
    
//    if(group.delegate && [group.delegate respondsToSelector:@selector(downloadProgress:withUrl:withProgress:withTotalRead:withTotalExpected:)]){
//        [group.delegate downloadProgress:groupName withUrl:url withProgress:group.groupProgress withTotalRead:totalRead withTotalExpected:expected];
//    }
}

-(void)downloadComplete:(HSDownloadState)downloadState withGroupName:(NSString*)groupName downLoadUrlString:(NSString *)downLoadUrlString
{
    HSDownloadState groupState = downloadState;
    NSLog(@"%d 完成状态",downloadState);
    AKDownloadGroupModel* group = [self getDownloadGroup:groupName];
    
    if(downloadState == HSDownloadStateCompleted){
        AKDownloadModel* model = [group currentModel];
        NSLog(@"%@ 完成",model.taskName );
        
        if([group isCompleted] == NO){
            [group goToNextModel];
            [self startGroup:group];
            return;
        }else{
            
        }
    }else{
        
    }
    
    group.onDownloadCompleted.fire(@{@"state":@(downloadState),@"groupName":groupName,@"url":downLoadUrlString});
    
//    if(group.delegate && [group.delegate respondsToSelector:@selector(downloadComplete:withGroupName:downLoadUrlString:)]){
//        [group.delegate downloadComplete:groupState withGroupName:groupName downLoadUrlString:downLoadUrlString];
//    }
    
}






@end
