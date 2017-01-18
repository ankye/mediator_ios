//
//  AKBookDetailAPI.m
//  Project
//
//  Created by ankye on 2017/1/18.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookDetailAPI.h"
#import "ReaderModuleDefine.h"


@interface AKBookDetailAPI()

@property (nonatomic,strong) NSString* siteID;
@property (nonatomic,strong) NSString* novelID;
@end

@implementation AKBookDetailAPI

-(instancetype) initWithNovelID:(NSString* )novelID withSiteID:(NSString*)siteID
{
    if (self = [super init])
    {
        self.siteID = siteID;
        self.novelID = novelID;
        
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
    return @"/api/novel/dir.json";
}

- (id)requestArgument{
    
    return @{
             @"novelid":_novelID,
             @"siteid": _siteID
             };
}

@end
