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

-(id)init
{
    if(self = [super init]){
        
        _currentTaskIndex = 0;
        _needStore = YES;
        _groupProgress = 0.0f;
        _groupState = HSDownloadStateNone;
        
    }
    return self;
}


-(void)resetSignals
{
    self.onDownloadProgress = (UBSignal<DictionarySignal> *)
    [[UBSignal alloc] initWithProtocol:@protocol(DictionarySignal)];
    self.onDownloadCompleted = (UBSignal<DictionarySignal> *)
    [[UBSignal alloc] initWithProtocol:@protocol(DictionarySignal)];
    self.task = nil;
    
}

-(CGFloat)calcProgress
{
    
    AKDownloadModel* model = [self.tasks objectAtIndex:self.currentTaskIndex];
  
    NSInteger total = [self.tasks count];
    if(total <= 0){
        _groupProgress = 0.0f;
    }else{
        
        if(self.enableBreakpointResume == NO &&
           self.currentTaskIndex >= [self.tasks count]-1 &&
            [[AKDownloadManager sharedInstance] isDownloadCompleted:self.groupName withUrl:[self currentModel].downLoadUrl]){
                    _groupProgress = 1.0f;
            
            
        }else{
            CGFloat singleFileProgress = 1.0f/total;
            CGFloat progress = (_currentTaskIndex +1.0f) /total - singleFileProgress * (1.0f -  model.progress);
            _groupProgress = progress;
        }
    }
    if(_groupProgress >= 1.0){
        _groupState = HSDownloadStateCompleted;
    }
    return _groupProgress;
    
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

//-(BOOL)isCompleted
//{
//    if(self.enableBreakpointResume){
//        if(self.groupProgress >= 1.0){
//            return YES;
//        }
//        return NO;
//    }else{
//        if(self.currentTaskIndex >= [self.tasks count]-1){
//           
//            return  [[AKDownloadManager sharedInstance] isDownloadCompleted:self.groupName withUrl:[self currentModel].downLoadUrl];
//        }else{
//            return NO;
//        }
//    }
//}


-(BOOL)isExistTask:(AKDownloadModel*)model
{
    NSInteger count = [self.tasks count];
    AKDownloadModel* tempModel = nil;
    for(NSInteger i=0; i< count; i++){
        tempModel = [self.tasks objectAtIndex:i];
        if(tempModel && [tempModel.downLoadUrl isEqualToString:model.downLoadUrl]){
            return YES;
        }
    }
    return NO;
}

-(void)addTaskModel:(AKDownloadModel*)model
{
    if(![self isExistTask:model]){
        [self.tasks addObject:model];
        _needStore = YES;
    }
}


//-(HSDownloadState)calcState
//{
//    if([self isCompleted]){
//        _groupState = HSDownloadStateCompleted;
//    }else {
//        if(self.enableBreakpointResume && self.task != nil){
//                _groupState =  self.task.state;
//        }
//    }
//    return _groupState;
//}

@end
