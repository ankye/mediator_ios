//
//  CustomTremblingItem.h
//  testGuoShanChe
//
//  Created by 陈行 on 16/8/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomTremblingItem : NSObject

@property (nonatomic, copy) NSString *normalImageName;

@property (nonatomic, copy) NSString *selectedImageName;

@property(nonatomic,strong)UIColor * normalColor;

@property(nonatomic,strong)UIColor * selectedColor;

@property (nonatomic, copy) NSString *normalTitle;

@property (nonatomic, copy) NSString *selectedTitle;

@property(nonatomic,assign)BOOL selected;

+ (NSMutableArray *)arrayWithPath:(NSString *)path;

@end
