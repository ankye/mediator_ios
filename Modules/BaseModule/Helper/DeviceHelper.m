//
//  DeviceHelper.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "DeviceHelper.h"
#import "AppHelper.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/sysctl.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <sys/utsname.h>
#import <dlfcn.h>

#include <ifaddrs.h>
#include <arpa/inet.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation DeviceHelper


//获取本机IP
+(NSString*)localIP {
    NSArray *searchArray = @[ IOS_VPN @"/" IP_ADDR_IPv4,
                              IOS_VPN @"/" IP_ADDR_IPv6,
                              IOS_WIFI @"/" IP_ADDR_IPv4,
                              IOS_WIFI @"/" IP_ADDR_IPv6,
                              IOS_CELLULAR @"/" IP_ADDR_IPv4,
                              IOS_CELLULAR @"/" IP_ADDR_IPv6 ];
    
    NSDictionary *addresses = [[self class] getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}



//获取网络IP
+(NSString*)networkIP
{
    return nil;
}

//获取渠道号
+ (NSString *)channel
{
    NSString* appChannel = APP_CHANNEL;
    if([AppHelper isNullString:appChannel]){
        appChannel = @"AppStore";
    }
    return appChannel;
}
//获取Api版本
+ (NSString *)apiVersion
{
     NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"apiVersion"];

    return [AppHelper isNullString:version]?@"1.0":version;
    
}
//获取App版本字符串
+ (NSString *)appStringVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString* version = infoDic[@"CFBundleShortVersionString"];
    
    return [AppHelper isNullString:version]?@"1.0":version;
}
//获取App版本数字号
+ (NSString *)appNumberVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString* version = infoDic[@"CFBundleVersion"];
    
    return [AppHelper isNullString:version]?@"1.0":version;
}


//获取设备系统os名称
+ (NSString *)deviceOSName
{
    NSString* name = [[UIDevice currentDevice] systemName];
    
    return [AppHelper isNullString:name]?@"ios":name;
}

//获取系统版本号
+ (NSString *)deviceOSVersion
{
    NSString* version = [[UIDevice currentDevice] systemVersion];
    return [AppHelper isNullString:version]?@"1.0":version;

}
//获取设备系统os
+ (NSString *)deviceOS
{
    return [NSString stringWithFormat:@"%@%@",self.deviceOSName, self.deviceOSVersion];
}
//获取IDFA
+ (NSString *)IDFA
{
    NSString* idfa = [[[[ASIdentifierManager alloc] init] advertisingIdentifier] UUIDString];
    
    return [AppHelper isNullString:idfa]?@"0.0.0.0":idfa;
}

//获取IDFV
+ (NSString*)IDFV
{
    NSString* idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [AppHelper isNullString:idfv]?@"0.0.0.0":idfv;
}

// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString*)macAddress
{
    NSString* result = @"0:0:0:0";
    int mib[6];
    size_t len;
    char* buf;
    unsigned char* ptr;
    struct if_msghdr* ifm;
    struct sockaddr_dl* sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return result;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return result;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return result;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return result;
    }
    
    ifm = (struct if_msghdr*)buf;
    sdl = (struct sockaddr_dl*)(ifm + 1);
    ptr = (unsigned char*)LLADDR(sdl);
    NSString* outstring = [NSString
                           stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1),
                           *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    return outstring;
}


+ (NSString *)devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
//获取设备名称 iphone/ipad/itouch
+ (NSString *)deviceName
{
    NSString *platform = [DeviceHelper devicePlatform];
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    // iPad mini
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
    // Simulator
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

/**
 *  获取当前系统语言
 *
 *  @return zh_CN, zh_TW, ja_JP, en_US
 */
+ (NSString *)localeLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *strLang = [languages firstObject];
    
    if ([strLang hasPrefix:@"zh-Hans"]) {
        strLang = @"zh_CN";
    } else if ([strLang hasPrefix:@"zh-Hant"]) {
        strLang = @"zh-TW";
    }
    
    return strLang;
}

//机器品牌
+ (NSString*)phoneBrand
{
    NSString* name = [[UIDevice currentDevice] name];
    return [AppHelper isNullString:name] ? @"iphone":name;
}
//手机型号
+ (NSString*)phoneModel
{
    NSString* name = [[UIDevice currentDevice] model];
    return [AppHelper isNullString:name] ? @"iphone":name;
}

@end
