//
//  CustomChooseCityModel.m
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomChooseCityModel.h"

@implementation CustomChooseCityModel

static NSArray * shareCityArray;

+ (NSArray *)sharedChooseCityModelList{
    if (shareCityArray==nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            NSMutableArray * dataArray=[NSMutableArray new];
            for (NSDictionary * dict in array) {
                [dataArray addObject:[CustomChooseCityModel customChooseCityModel:dict]];
            }
            shareCityArray = dataArray;
        });
    }
    return shareCityArray;
}

+ (instancetype)customChooseCityModel:(NSDictionary *)dict{
    CustomChooseCityModel * model=[CustomChooseCityModel new];
    [model setValuesForKeysWithDictionary:dict];
    if(model.cities){
        NSMutableArray * array=[NSMutableArray new];
        for (NSObject* obj in model.cities) {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary * tmp = (NSDictionary *) obj;
                [array addObject:[CustomChooseCityModel customChooseCityModel:tmp]];
            }else if([obj isKindOfClass:[NSString class]]){
                CustomChooseCityModel * tmp = [CustomChooseCityModel new];
                tmp.title=(NSString *)obj;
                [array addObject:tmp];
            }
        }
        model.cities=array;
    }
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"state"]){
        self.title=value;
    }else if ([key isEqualToString:@"city"]){
        self.title=value;
    }
    
    if([key isEqualToString:@"cities"]){
        self.cities=value;
    }else if ([key isEqualToString:@"areas"]){
        self.cities=value;
    }
}

@end
