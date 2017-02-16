//
//  LocationHelper.h
//  Project
//
//  Created by ankye on 2017/2/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject


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


SINGLETON_INTR(LocationHelper)
/**
 获得2个点直接的距离,单位米
 
 @param from 起始点
 @param to 结束点
 @return 返回距离
 */
+(int) getDistance:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;

+(int) getDistance:(double)latitude longitude:(double)longitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude;



@end
