//
//  BSNumbersDataManager.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSNumbersDataManager : NSObject

@property (assign, nonatomic) CGFloat minItemWidth;
@property (assign, nonatomic) CGFloat maxItemWidth;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemTextHorizontalMargin;
@property (assign, nonatomic) NSInteger freezeColumn;
@property (assign, nonatomic) UIFont *headerFont;
@property (assign, nonatomic) UIFont *slideBodyFont;

@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;

- (void)caculate;

@property (strong, nonatomic, readonly) NSArray<NSString *> *headerFreezeData;
@property (strong, nonatomic, readonly) NSArray<NSString *> *headerSlideData;

@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *bodyFreezeData;
@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *bodySlideData;

@property (assign, nonatomic, readonly) CGFloat freezeWidth;
@property (assign, nonatomic, readonly) CGFloat slideWidth;

@property (strong, nonatomic, readonly) NSArray<NSString *> *freezeItemSize;
@property (strong, nonatomic, readonly) NSArray<NSString *> *slideItemSize;

@end
