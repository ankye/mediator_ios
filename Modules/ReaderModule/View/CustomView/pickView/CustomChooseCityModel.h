//
//  CustomChooseCityModel.h
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomChooseCityModel : NSObject

@property(nonatomic,assign)NSInteger Id;

@property(nonatomic,strong)NSArray * cities;

@property(nonatomic,copy)NSString * title;

+ (NSArray *)sharedChooseCityModelList;

+ (instancetype)customChooseCityModel:(NSDictionary *)dict;

@end
