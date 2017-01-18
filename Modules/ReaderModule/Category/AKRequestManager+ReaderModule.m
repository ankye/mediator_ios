//
//  AKRequestManager+ReaderModule.m
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKRequestManager+ReaderModule.h"
#import "AKReaderHotListAPI.h"
#import "AKBookDetailAPI.h"
#import "AKBookChapterAPI.h"
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

-(BOOL)reader_requestBookDetailWithNovelID:(NSString*)novelID withSiteID:(NSString*)siteID success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    AKBookDetailAPI *api = [[AKBookDetailAPI alloc] initWithNovelID:novelID withSiteID:siteID];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
    
    return YES;
}

-(BOOL)reader_requestBookChapterWithURL:(NSString*)url success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    AKBookChapterAPI *api = [[AKBookChapterAPI alloc] initWithRequestURL:url];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
    
    return YES;
}
@end
