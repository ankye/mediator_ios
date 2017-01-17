//
//  CustomTremblingItem.m
//  testGuoShanChe
//
//  Created by 陈行 on 16/8/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomTremblingItem.h"

@implementation CustomTremblingItem

+ (NSMutableArray *)arrayWithPath:(NSString *)path{
    NSMutableArray * dataArray = [NSMutableArray new];
    
    NSArray * tmpDataArray = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary * dict in tmpDataArray) {
        CustomTremblingItem * item = [CustomTremblingItem new];
        [item setValuesForKeysWithDictionary:dict];
        [dataArray addObject:item];
    }
    return dataArray.count?dataArray:nil;
}

@end
