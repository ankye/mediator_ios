//
//  AKIMTokenRequest.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKIMTokenRequest.h"


@interface AKIMTokenRequest()

@property(strong, nonatomic) NSString *uid;

@end

@implementation AKIMTokenRequest

-(instancetype) init:(NSString*)uid
{
    if (self = [super init])
    {
        self.uid        = uid;     
    }
    return self;
}

-(NSString *)baseUrl
{
    return G_BASE_IM_AUTH_SITE;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"/room/imtoken";
}

- (id)requestArgument{
    
    return @{
             @"room_uid": _uid
             };
}



@end

