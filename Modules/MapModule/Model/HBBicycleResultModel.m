//
//  HBBicycleResultModel.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleResultModel.h"
#import "HBBicycleStationModel.h"

@implementation HBBicycleResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data":[HBBicycleStationModel class],
             };
}
@end
