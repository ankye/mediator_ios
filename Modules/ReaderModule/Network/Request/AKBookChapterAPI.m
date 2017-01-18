//
//  AKBookDetailAPI.m
//  Project
//
//  Created by ankye on 2017/1/18.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookChapterAPI.h"
#import "ReaderModuleDefine.h"


@interface AKBookChapterAPI()

@property (nonatomic,strong) NSString* requestURL;

@end

@implementation AKBookChapterAPI

-(instancetype) initWithRequestURL:(NSString*)url
{
    if (self = [super init])
    {
        self.requestURL = url;
        
    }
    return self;
}

-(NSString *)baseUrl
{
    return @"";
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return self.requestURL;
}



@end
