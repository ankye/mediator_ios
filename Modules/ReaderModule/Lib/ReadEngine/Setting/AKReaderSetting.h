//
//  AKReaderSetting.h
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadEngineDefine.h"

@interface AKReaderSetting : NSObject

SINGLETON_INTR(AKReaderSetting)

@property (strong, nonatomic) NSString *fontName;         //字体
@property (assign, nonatomic) BOOL isTraditional;   //是否繁体
@property (assign, nonatomic) AKPagingLineSpaceType lineSpaceType;  //行间距
@property (assign, nonatomic) AKReaderTheme theme;  //主题设置
@property (assign, nonatomic) AKTurnPageAnimationStyle pageStyle; //翻页动画
@property (assign, nonatomic) BOOL isNightMode;     //是否夜间模式
@property (assign, nonatomic) CGFloat fontSize;     //字体大小

@property (strong, nonatomic, readonly) UIColor *textColor;
@property (strong, nonatomic, readonly) UIColor *otherTextColor;//其他如标题,电池,时间等

@property (strong, nonatomic, readonly) UIImage *themeImage;


//主题选择
-(void)selectdTheme:(AKReaderTheme)theme;

@end
