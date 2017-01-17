//
//  CustomChooseCityView.h
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomChooseCityModel.h"
#import "CustomPickView.h"

@protocol CustomChooseCityViewDelegate <NSObject>

- (void)customChooseCityViewAndSelectedArray:(NSArray *)selectedArray andDataArray:(NSArray *)dataArray andValue:(NSString *)value;

@end

@interface CustomChooseCityView : UIView

@property(nonatomic,strong)NSArray * cityDataArray;

@property(nonatomic,weak)id<CustomChooseCityViewDelegate>delegate;

- (void)showPickView;

- (void)hiddenPickView;

@end
