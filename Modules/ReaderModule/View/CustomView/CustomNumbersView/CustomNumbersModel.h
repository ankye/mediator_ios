//
//  CustomNumbersModel.h
//  powerlife
//
//  Created by 陈行 on 16/7/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNumbersModel : NSObject
/**
 *  每个组组名称
 */
@property (nonatomic, copy) NSString *titleName;
/**
 *  cell的name
 */
@property(nonatomic,strong)NSArray * cellNameDataArray;
/**
 *  cell对应数据模型的key值，显示在内容区域
 */
@property(nonatomic,strong)NSArray * cellValueKeyDataArray;

@end
