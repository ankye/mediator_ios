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

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;


#define ImageInName(name) [UIImage imageNamed:name]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;



#define kNotificationOfflineMapFinished  @"kNotificationOfflineMapFinished"


#endif /* AKMapModuleDefine_h */
