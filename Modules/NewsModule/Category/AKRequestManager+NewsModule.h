//
//  AKRequestManager+NewsModule.h
//  Project
//
//  Created by ankye on 2016/12/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@interface AKRequestManager (NewsModule)

//请求ChannelList
-(BOOL)news_requestChannelListWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

//请求新闻列表
-(BOOL)news_requestContentList:(NSString*)cid withPageSize:(NSInteger)pagesize withSendTime:(double)time WithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;
@end
