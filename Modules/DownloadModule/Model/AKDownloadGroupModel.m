//
//  DownloadGroupModel.m
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDownloadGroupModel.h"
#import "HSDownloadManager.h"
#import "SGDownloadManager.h"
#import "AKDownloadManager.h"

@interface AKDownloadGroupModel()

@end

@implementation AKDownloadGroupModel

-(CGFloat)groupProgress
{
    AKDownloadModel* model = [self.tasks objectAtIndex:self.currentTaskIndex];
    
    CGFloat singleFileProgress = 1.0f/(_endIndex - _startIndex + 1.0f);
    CGFloat progress = (_currentTaskIndex - _startIndex+1.0f) /(_endIndex - _startIndex+1.0f) - singleFileProgress * (1.0f -  model.progress);
    return progress;
    
}

-(AKDownloadModel*)currentModel
{
    if(self.currentTaskIndex >= [self.tasks count]) return nil;
    return self.tasks ? self.tasks[self.currentTaskIndex] : nil;
}

-(AKDownloadModel*)goToNextModel
{
    NSInteger nextIndex = self.currentTaskIndex + 1;
    if(nextIndex < [self.tasks count]){
        if(self.enableBreakpointResume){
            _task = nil;
        }
        self.currentTaskIndex = nextIndex;
        return [self currentModel];
    }
    return nil;
}
-(BOOL)isCompleted
{
    if(self.enableBreakpointResume){
        if(self.groupProgress >= 1.0){
            return YES;
        }
        return NO;
    }else{
        if(self.currentTaskIndex >= [self.tasks count] -1){
           
            return  [[AKDownloadManager sharedInstance] isDownloadCompleted:self.groupName withUrl:[self currentModel].downLoadUrl];
        }else{
            return NO;
        }
    }
}



-(void)addTaskModel:(AKDownloadModel*)model
{
    [self.tasks addObject:model];
}


-(HSDownloadState)state
{
    if([self isCompleted]){
        return HSDownloadStateCompleted;
    }else {
        if(self.enableBreakpointResume && self.task != nil){
                return self.task.state;
        }else{
            return HSDownloadStateSuspended;
        }
    }
}

@end
