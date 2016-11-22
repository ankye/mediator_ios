//
//  UIDevice+SoftwareInfo.h
//  JK360
//
//  Created by wenlong on 16/5/3.
//  Copyright © 2016年 youyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SoftwareInfo)

+ (NSString *)genTimestamp;
+ (NSString *)channel;
+ (NSNumber *)apiVersion;
+ (NSString *)deviceName;
+ (NSString *)deviceOSName;
+ (NSString *)deviceOSVersion;
+ (NSString *)deviceOS;
+ (NSString *)idfa;
+ (NSString *)appStringVersion;
+ (NSString *)appNumberVersion;
@end
