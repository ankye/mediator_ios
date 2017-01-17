//
//  InitialData.h
//  powerlife
//
//  Created by 陈行 on 16/6/16.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface InitialData : NSObject
/**
 *  定位之后用户所在省
 */
@property (nonatomic, copy) NSString *userLocalProvince;
/**
 *  定位之后用户所在市
 */
@property (nonatomic, copy) NSString *userLocalCity;
/**
 *  定位之后用户所在区
 */
@property (nonatomic, copy) NSString *userLocalSubLocality;
/**
 *  定位之后用户高德经纬度
 */
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate;
/**
 *  appVersion
 */
@property (nonatomic, copy) NSString *appVersion;

@property (nonatomic, copy) NSString *appName;

@property(nonatomic,strong)UIColor * readBackgroundColor;

@property (nonatomic, assign) NSInteger readFontNum;

@property (nonatomic, assign) NSInteger readTextSpace;

+ (instancetype)sharedInitialData;

@end
