//
//  UIColor+TLChat.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>

#define     TLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


@interface UIColor (TLChat)

#pragma mark - # 字体
+ (UIColor *)colorTextBlack;
+ (UIColor *)colorTextGray;
+ (UIColor *)colorTextGray1;


#pragma mark - 灰色
+ (UIColor *)colorGrayBG;           // 浅灰色默认背景
+ (UIColor *)colorGrayCharcoalBG;   // 较深灰色背景（聊天窗口, 朋友圈用）
+ (UIColor *)colorGrayLine;
+ (UIColor *)colorGrayForChatBar;
+ (UIColor *)colorGrayForMoment;



#pragma mark - 绿色
+ (UIColor *)colorGreenDefault;


#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment;


#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar;
+ (UIColor *)colorBlackBG;
+ (UIColor *)colorBlackAlphaScannerBG;
+ (UIColor *)colorBlackForAddMenu;
+ (UIColor *)colorBlackForAddMenuHL;


@end
