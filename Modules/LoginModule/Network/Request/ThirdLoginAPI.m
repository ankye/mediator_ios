//
//  ThirdLoginAPI.m
//  XYTV
//
//  Created by huk on 16/1/27.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "ThirdLoginAPI.h"
#import "DeviceHelper.h"


@interface ThirdLoginAPI()

@property(strong, nonatomic) NSString *openid;

@property(strong, nonatomic) NSString *token;

@property(strong, nonatomic) NSString *type;

@property(strong, nonatomic) NSString *deviceId;

@end

@implementation ThirdLoginAPI
-(instancetype) init:(NSString *)openid withToken:(NSString *)token andType:(NSString *)type
{
    if (self = [super init])
    {
        self.openid     = openid;
        self.token      = token;
        self.type       = type;
        self.deviceId   = [DeviceHelper macAddress];
    }
    return self;
}

-(NSString *)baseUrl
{
    return G_BASE_AUTH_SITE;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return @"/login/extResponse";
}

- (id)requestArgument{
    
    return @{
             @"access_token": _token    ? _token    : @"",
             @"openid"      : _openid   ? _openid   : @"",
             @"type"        : _type     ? _type     : @"",
             @"deviceID"    : _deviceId ? _deviceId : @"",
             };
}



@end
