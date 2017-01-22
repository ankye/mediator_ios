//
//  AKDownloadManager.h
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKDownloadGroupModel.h"

@interface AKDownloadManager : NSObject

@property (nonatomic,strong) YYThreadSafeArray* downloadList;

SINGLETON_INTR(AKDownloadManager)

-(BOOL)isEmptyList;


-(AKDownloadModel*)createTask:(NSString*)groupName withTaskName:(NSString*)taskName withIcon:(NSString*)icon withDesc:(NSString*)desc withDownloadUrl:(NSString*)downloadUrl withFilename:(NSString*)filename;

-(AKDownloadGroupModel*)createTaskGroup:(NSString*)groupName downloadDir:(NSString*)dir withTasks:(NSMutableArray<AKDownloadModel*>*)tasks start:(NSInteger)start end:(NSInteger)end current:(NSInteger)current;

@end
