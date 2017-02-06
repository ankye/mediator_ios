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

- (NSMutableArray *)downloadList
{
    if (_downloadList == nil) {
        
        [self loadCacheList];
        if(_downloadList == nil){
            _downloadList = [[NSMutableArray alloc] init];
  
        }
        
    }
    return _downloadList ;
    
  
}

-(NSString*)downloadListPlistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取完整路径
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"AKDownloadList.plist"];

  
    return  plistPath;
    
}

-(NSMutableArray*)loadCacheList
{
   
    NSString *plistPath = [self downloadListPlistPath];
    
    NSData* data = [[NSData alloc] initWithContentsOfFile:plistPath];
    if(data){
        _downloadList = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSInteger count = [_downloadList count];
        for(NSInteger i=0; i<count; i++){
            AKDownloadGroupModel* group = [_downloadList objectAtIndex:i];
            if(group){
                [group resetSignals];
            }
        }
    }else{
        _downloadList = nil;
    }
    return _downloadList;
    
}

-(void)storeDownloadList
{
    NSString *plistPath = [self downloadListPlistPath];

    
    NSLog(@"%@",plistPath);
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableArray *dictplist = [[NSMutableArray alloc] init];
        
       NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dictplist];
        
        [data writeToFile:plistPath atomically:YES];
    
    }
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.downloadList];
    
    [data writeToFile:plistPath atomically:YES];
   
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
    if(model.progress >= 1.0){
        model.isCached = YES;
    }else{
        model.isCached = NO;
    }
    return model;
}


-(AKDownloadGroupModel*)createTaskGroup:(NSString*)groupName withBreakpointResume:(BOOL)breakpointResume
{
    AKDownloadGroupModel* group = [[AKDownloadGroupModel alloc] init];
    group.groupName = groupName;
    group.tasks = [[NSMutableArray alloc] init];
    group.currentTaskIndex = 0;

    group.enableBreakpointResume = breakpointResume;
  
    [group resetSignals];
    
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
   

    [group calcProgress];
    
    if(group.needStore){
        group.needStore = NO;
        [self storeDownloadList];
        
    }

    
    if(group.enableBreakpointResume){
        if(model && model.isCached ){
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

-(void)checkGroupDir:(NSString*)groupName
{
    NSString* path = [self getDownloadGroupDir:groupName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
}

-(void)removeGroupDir:(NSString*)groupName
{
    NSString* path = [self getDownloadGroupDir:groupName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
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
    if(index > [group.tasks count] || index < 0){
        return;
    }
    [self pauseGroup:group];
    
    group.currentTaskIndex = index;
    
    [self startGroup:group];
    
}


-(void)pauseGroup:(AKDownloadGroupModel*)group
{
    if(group.groupState == HSDownloadStateCompleted || group.groupState == HSDownloadStateSuspended){
        return;
    }
    [group calcProgress];
    AKDownloadModel* model = [group currentModel];
    if(group.enableBreakpointResume){
        [[HSDownloadManager sharedInstance] pause:model.downLoadUrl group:group.groupName];
    }else{
        group.groupState = HSDownloadStateSuspended;
        [[SGDownloadManager shareManager] supendDownloadWithUrl:model.downLoadUrl];
    }
    group.groupState = HSDownloadStateSuspended;
    
    [self storeDownloadList];

}

-(void)deleteGroup:(AKDownloadGroupModel*)group
{
    [self pauseGroup:group];
    [self removeGroupDir:group.groupName];
    
    [self.downloadList removeObject:group];
    
    [self storeDownloadList];

}



-(void)downloadProgress:(NSString*)groupName withUrl:(NSString*)url withProgress:(CGFloat)progress withTotalRead:(CGFloat)totalRead withTotalExpected:(CGFloat)expected
{
    AKDownloadGroupModel* group = [self getDownloadGroup:groupName];
    [group currentModel].progress = progress;

    [group calcProgress];
  group.onDownloadProgress.fire(@{@"groupName":groupName,@"url":url,@"progress":@(progress),@"totalRead":@(totalRead),@"expected":@(expected)});
    
//    if(group.delegate && [group.delegate respondsToSelector:@selector(downloadProgress:withUrl:withProgress:withTotalRead:withTotalExpected:)]){
//        [group.delegate downloadProgress:groupName withUrl:url withProgress:group.groupProgress withTotalRead:totalRead withTotalExpected:expected];
//    }
}

-(void)downloadComplete:(HSDownloadState)downloadState withGroupName:(NSString*)groupName downLoadUrlString:(NSString *)downLoadUrlString
{
    NSLog(@"%d 完成状态",downloadState);
    AKDownloadGroupModel* group = [self getDownloadGroup:groupName];
    [group calcProgress];
    
    if(downloadState == HSDownloadStateCompleted){
        AKDownloadModel* model = [group currentModel];
        NSLog(@"%@ 完成",model.taskName );
        
        model.isCached = YES;
        
        if(group.groupState != HSDownloadStateCompleted){
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
