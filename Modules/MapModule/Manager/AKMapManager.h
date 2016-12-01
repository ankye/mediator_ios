//
//  AKMapManager.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKMapManager : NSObject < AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) UserModel* me;

@property (nonatomic,strong) NSMutableArray* userlist;
@property (nonatomic,strong) NSMutableArray* friendList;
SINGLETON_INTR(AKMapManager);

-(void)reloadLocation;
@end
