//
//  AKRequestManager+NewsModule.m
//  Project
//
//  Created by ankye on 2016/12/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager+NewsModule.h"
#import "ChannelListAPI.h"

@implementation AKRequestManager (NewsModule)


-(BOOL)news_requestChannelListWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    ChannelListAPI *api = [[ChannelListAPI alloc] init];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
    
    return YES;
}
@end
