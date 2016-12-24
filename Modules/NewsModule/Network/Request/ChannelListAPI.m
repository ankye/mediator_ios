//
//  ChannelListAPI.m


#import "ChannelListAPI.h"
#import "DeviceHelper.h"
#import "NewsModuleDefine.h"


@implementation ChannelListAPI


-(NSString *)baseUrl
{
    return AK_NEWS_SERVER;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"kind/all";
}



@end
