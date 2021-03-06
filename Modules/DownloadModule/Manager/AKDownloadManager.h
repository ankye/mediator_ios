//
//  AKDownloadManager.h
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKDownloadGroupModel.h"
#import "HSDownloadTask.h"

@interface AKDownloadManager : NSObject <HSDownloadTaskDelegate>

@property (nonatomic,strong) dispatch_queue_t   myQueue ;
@property (nonatomic,strong) NSMutableArray* downloadList;

SINGLETON_INTR(AKDownloadManager)

-(BOOL)isEmptyList;


-(AKDownloadModel*)createTask:(NSString*)groupName withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename;

-(AKDownloadGroupModel*)createTaskGroup:(NSString*)groupName withBreakpointResume:(BOOL)breakpointResume;

-(AKDownloadGroupModel*)createSingleFileGroup:(NSString*)groupName withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename;

-(void)startGroup:(AKDownloadGroupModel*)group;
-(void)pauseGroup:(AKDownloadGroupModel*)group;
-(void)deleteGroup:(AKDownloadGroupModel*)group;

-(void)startGroup:(AKDownloadGroupModel*)group atIndex:(NSInteger)index;


-(AKDownloadGroupModel*)getDownloadGroup:(NSString*)groupName;
-(AKDownloadModel*)getDownloadModel:(NSString*)groupName withUrl:(NSString*)url;

-(BOOL) isDownloadCompleted:(NSString*)group withUrl:(NSString*)url;

-(NSString*)getDownloadFilePath:(NSString*)group withUrl:(NSString*)url;

@end
