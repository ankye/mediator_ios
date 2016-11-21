//
//  AKMapModuleDefine.h
//  Project
//
//  Created by ankye on 2016/11/19.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef AKMapModuleDefine_h
#define AKMapModuleDefine_h

#import <CoreLocation/CoreLocation.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


//字体
#define HB_FONT_LIGHT_SIZE(x) [UIFont fontWithName:@"STHeitiSC-Light" size:x]
#define HB_FONT_MEDIUM_SIZE(x) [UIFont fontWithName:@"STHeitiSC-Medium" size:x]

//颜色
#define HB_COLOR_DARKBLUE FHColorWithHexRGB(0x4F6C87)
#define HB_COLOR_SOFTGREEN FHColorWithHexRGB(0xB3D66E)
#define HB_COLOR_SOFTORANGE FHColorWithHexRGB(0xF8931D)
#define HB_COLOR_TABLEVAIEWBACK FHColorWithHexRGB(0x8a8a8a)

#define HB_COLOR_SLDMIN FHColorWithHexRGB(0x529ECD)
#define HB_COLOR_SLDMID [UIColor lightGrayColor]
#define HB_COLOR_SLDMAX FHColorWithHexRGB(0x4C5A68)


#define ImageInName(name) [UIImage imageNamed:name]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;



#define kNotificationOfflineMapFinished  @"kNotificationOfflineMapFinished"


#endif /* AKMapModuleDefine_h */
