//
//  LocationHelper.m
//  Project
//
//  Created by ankye on 2017/2/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "LocationHelper.h"
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationHelper()<CLLocationManagerDelegate>

@property(nonatomic,retain)CLLocationManager *locationManager;
/**
 *  经纬度反编译
 */
@property(nonatomic,assign)BOOL isReverseGeocodeLocation;

@end


@implementation LocationHelper

SINGLETON_IMPL(LocationHelper)

-(id)init
{
    self = [super init];
    if(self){
        self.userLocalProvince=@"北京市";
        self.userLocalCity=@"北京市";
        self.userLocalSubLocality=@"东城区";
        self.userCoordinate =CLLocationCoordinate2DMake(39.9040300000, 116.4075260000);
    }
    return self;
}

#pragma mark - 定位相关
- (void)locate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0 && self.isReverseGeocodeLocation==false){
            self.isReverseGeocodeLocation=true;
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            //省市县
            self.userLocalProvince=placemark.administrativeArea;
            self.userLocalCity = placemark.locality;
            self.userLocalSubLocality=placemark.subLocality;
            self.userCoordinate = placemark.location.coordinate;
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)getProvice{
    NSArray * array=@[@"39.9040300000,116.4075260000",
                      @"39.0841580000,117.2009830000",
                      @"29.5630100000,106.5515570000",
                      @"31.8611840000,117.2849230000",
                      @"26.1007800000,119.2951440000",
                      @"23.1321910000,113.2665310000",
                      @"22.8154780000,108.3275460000",
                      @"26.5981940000,106.7074100000",
                      @"36.0594210000,103.8263080000",
                      @"20.0173780000,110.3492290000",
                      @"34.4451220000,113.2743790000",
                      @"45.7423470000,126.6616690000",
                      @"30.5464980000,114.3418620000",
                      @"28.1124440000,112.9838100000",
                      @"38.5848540000,114.4757040000",
                      @"32.0617070000,118.7632320000",
                      @"28.6756970000,115.9092280000",
                      @"43.8965360000,125.3259900000",
                      @"41.8354410000,123.4294400000",
                      @"38.4713180000,106.2587540000",
                      @"40.8174980000,111.7656180000",
                      @"36.6209010000,101.7801990000",
                      @"36.6685300000,117.0203590000",
                      @"37.8735320000,112.5623980000",
                      @"34.2654720000,108.9542390000",
                      @"45.2588810000,127.2259060000",
                      @"43.7930260000,87.6277040000",
                      @"29.6469230000,91.1172120000",
                      @"25.0458060000,102.7100020000",
                      @"30.2674470000,120.1527920000"];
    NSMutableArray * tmpArray = [NSMutableArray new];
    for (NSString * ll in array) {
        NSArray * arr = [ll componentsSeparatedByString:@","];
        CLLocationDegrees latitude = [arr[0] doubleValue];
        CLLocationDegrees longitude = [arr[1] doubleValue];
        [tmpArray addObject: [[CLLocation alloc]initWithLatitude:latitude longitude:longitude]];
    }
    
    for (CLLocation *currentLocation in tmpArray) {
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
            if (array.count > 0){
                CLPlacemark *placemark = [array objectAtIndex:0];
                //省市县
                NSLog(@"省：%@---市：%@---纬度：%f---经度：%f",placemark.administrativeArea,placemark.locality,placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            }
        }];
    }
}


/**
 获得2个点直接的距离,单位米
 
 @param from 起始点
 @param to 结束点
 @return 返回距离
 */
+(int) getDistance:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(from);
    MAMapPoint point2 = MAMapPointForCoordinate(to);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return (int)distance;
}

+(int) getDistance:(double)latitude longitude:(double)longitude toLatitude:(double)toLatitude toLongitude:(double)toLongitude
{
    return [LocationHelper getDistance:CLLocationCoordinate2DMake(latitude, longitude) to:CLLocationCoordinate2DMake(toLatitude, toLongitude)];
}


@end
