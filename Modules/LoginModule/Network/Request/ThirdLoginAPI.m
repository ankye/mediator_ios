//
//  ThirdLoginAPI.m
//  XYTV
//
//  Created by huk on 16/1/27.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "ThirdLoginAPI.h"
#import "DeviceInfo.h"

@interface ThirdLoginAPI()

@property(strong, nonatomic) NSString *openid;

@property(strong, nonatomic) NSString *token;

@property(strong, nonatomic) NSString *type;

@property(strong, nonatomic) NSString *deviceId;

@end

@implementation ThirdLoginAPI
-(instancetype) init:(NSString *)openid WithToken:(NSString *)token AndType:(NSString *)type
{
    if (self = [super init])
    {
        self.openid     = openid;
        self.token      = token;
        self.type       = type;
        self.deviceId   = [TTDADeviceInfo deviceIdentifer];
    }
    return self;
}

-(NSString *)baseUrl
{
    return M_PASSPORT_URL_Base;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl{
    return @"/login/extResponse";
}

- (id)requestArgument{
    if (![self verifyProperties]) {
        return nil;
    }

    return @{
             @"access_token": _token    ? _token    : @"",
             @"openid"      : _openid   ? _openid   : @"",
             @"type"        : _type     ? _type     : @"",
             @"deviceID"    : _deviceId ? _deviceId : @"",
             };
}

/**
 *  请求数据方法,复写父类的方法
 *
 */

- (void)bl_data:(NSDictionary *)dic{
    NSUInteger errcode = [dic[@"errcode"] integerValue];
    if (errcode != 0) {
        NSLog(@"login error");
        return;
    }
    
    if (dic[@"data"]) {
        self.bl_model = [UserModel objectWithKeyValues:dic[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil userInfo:@{@"UserModel":self.bl_model}];
    }else {
        self.bl_error = EmptyError;
    }

}

- (void)bl_error:(NSError *)error{
    [super bl_error:error];
}


@end
