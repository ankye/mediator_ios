//
//  AKNewsContentList.m
//  Project
//
//  Created by ankye on 2016/12/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKReaderHotListAPI.h"

#import "ReaderModuleDefine.h"


@interface AKReaderHotListAPI()

@property(assign, nonatomic) NSInteger page;


@end

@implementation AKReaderHotListAPI

-(instancetype) initWithPage:(NSInteger )page
{
    if (self = [super init])
    {
        self.page = page;
       
    }
    return self;
}

-(NSString *)baseUrl
{
    return READER_SERVER;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"/api/novel/list.json";
}

- (id)requestArgument{
    
    return @{
             @"order":@"allvisit",
             @"sort"    :@"desc",
             @"pagesize"        : @(20),
             @"isgood" : @"1",
             @"page" :  _page     ? @(_page)     : @(1)
             };
}

@end


