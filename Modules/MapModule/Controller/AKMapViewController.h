//
//  AKMapViewController.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModuleDefine.h"


@interface AKMapViewController : AKBaseViewController


@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end
