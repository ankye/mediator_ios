//
//  UIDevice+SoftwareInfo.m
//  JK360
//
//  Created by wenlong on 16/5/3.
//  Copyright © 2016年 youyi. All rights reserved.
//

#import "UIDevice+SoftwareInfo.h"
#import "DeviceInformation.h"


@implementation UIDevice (SoftwareInfo)

+ (NSString*)channel{
    return @"AppStore";
}
+ (NSString*) genTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[[NSBundle mainBundle] localizedStringForKey:@"yyyyMMddHHmmss" value:@"" table:nil]];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSNumber *)apiVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"API version"];
}
+ (NSString *)deviceName{
    return @"iPhone";
}
+ (NSString *)deviceOSName {
    return [[UIDevice currentDevice] systemName];
}
+ (NSString *)deviceOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)deviceOS {
    return [NSString stringWithFormat:@"%@%@",self.deviceOSName, self.deviceOSVersion];
}
+ (NSString *)idfa {
    return [[DeviceInformation sharedInstance] idfa];
}
+ (NSString *)appStringVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return infoDic[@"CFBundleShortVersionString"];
}
+ (NSString *)appNumberVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return infoDic[@"CFBundleVersion"];

}
@end
