//
//  AKNewsContentList.m
//  Project
//
//  Created by ankye on 2016/12/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsContentListAPI.h"

#import "NewsModuleDefine.h"


@interface AKNewsContentListAPI()

@property(strong, nonatomic) NSString *cid;

@property(assign, nonatomic) NSInteger pagesize;

@property(assign, nonatomic) double sendTime;



@end

@implementation AKNewsContentListAPI

-(instancetype) initWithChannel:(NSString *)cid withPageSize:(NSInteger )pagesize andSendTime:(double)sendTime
{
    if (self = [super init])
    {
        self.cid = cid;
        self.pagesize = pagesize;
        self.sendTime = sendTime;
    }
    return self;
}

-(NSString *)baseUrl
{
    return AK_NEWS_SERVER;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return @"/content/alist";
}

- (id)requestArgument{
    
    return @{
             @"kind"        : _cid ?_cid    : @"",
             @"sendtime"    :_sendTime   ? @(_sendTime)   : @(0),
             @"size"        : _pagesize     ? @(_pagesize)     : @(20)
             };
}

@end


