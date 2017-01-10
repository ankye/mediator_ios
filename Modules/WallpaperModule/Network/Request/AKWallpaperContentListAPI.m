//
//  AKNewsContentList.m
//  Project
//
//  Created by ankye on 2016/12/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKWallpaperContentListAPI.h"

#import "NewsModuleDefine.h"


@interface AKWallpaperContentListAPI()

@property(assign, nonatomic) NSInteger pagesize;


@end

@implementation AKWallpaperContentListAPI

-(instancetype) initWithPageSize:(NSInteger )pagesize
{
    if (self = [super init])
    {
        self.pagesize = pagesize;
       
    }
    return self;
}

-(NSString *)baseUrl
{
    return AK_WALLPAPER_SERVER;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"/api/sns/v2/homefeed";
}

/**
 deviceId=E598E960-024B-44BA-9F60-E1297C36FC35
 lang=zh-Hans
 num=20
 platform=iOS
 sid=session.1148128034373166113
 sign=a20b3aecf2efe34d01d0dcefc24cec2a&t=1463632659
 value=simple
 */
- (id)requestArgument{
    
    return @{
             @"deviceId":@"E598E960-024B-44BA-9F60-E1297C36FC35",
             @"lang"    :@"zh-Hans",
             @"num"        : _pagesize     ? @(_pagesize)     : @(20),
             @"platform" : @"iOS",
             @"sid" : @"session.1148128034373166113",
             @"sign": @"a20b3aecf2efe34d01d0dcefc24cec2a",
             @"t": @(1463632659),
             @"value": @"simple"
             };
}

@end


