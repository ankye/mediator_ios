//
//  ReadEngineDefine.h
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#ifndef ReadEngineDefine_h
#define ReadEngineDefine_h

// 动画样式
typedef NS_ENUM(NSInteger, AKTurnPageAnimationStyle) {
    TheSimulationEffectOfPage  = 0,// 仿真翻页
    TheKeepOutEffectOfPage     = 1,// 覆盖翻页
    TheSlidingEffectOfPage     = 2,// 滑动页面
    TheNoAnimationEffectOfPage = 3, // 没有动画
    TheTBSlidingEffectOfPage = 4   //上下翻页
};


typedef NS_ENUM(NSInteger,AKReaderTheme) {
    AKReaderThemeDay,           //白色
    AKReaderThemeParchement,    //羊皮纸
    AKReaderThemeWater,         //水波纹
    AKReaderThemeYellow,        //黄色
    AKReaderThemeGreen,         //绿色
    AKReaderThemeSheepskin,     //羊皮纸2
    AKReaderThemeViolet,        //紫色
    AKReaderThemePink,          //粉色
    AKReaderThemeLightGreen,    //护眼色
    AKReaderThemeLightPink,     //浅粉色
    AKReaderThemeCoffee,        //咖啡色
    AKReaderThemeBlackGreen     //黑色
};


typedef enum AKPagingLineSpaceType {
    
    AKPagingLineSpaceTypeSmall = 1,   //紧缩
    AKPagingLineSpaceTypeNormal = 2,  //正常
    AKPagingLineSpaceTypeLarge = 3    //扩大
}AKPagingLineSpaceType;



#endif /* ReadEngineDefine_h */
