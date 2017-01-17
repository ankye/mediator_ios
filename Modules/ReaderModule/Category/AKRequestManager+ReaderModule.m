//
//  AKRequestManager+ReaderModule.m
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKRequestManager+ReaderModule.h"
#import "AKReaderHotListAPI.h"

@implementation AKRequestManager (ReaderModule)


-(BOOL)reader_requestHotListWithPage:(NSInteger)page success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    AKReaderHotListAPI *api = [[AKReaderHotListAPI alloc] initWithPage:page];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
    
    return YES;
}
@end
