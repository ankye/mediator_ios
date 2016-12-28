//
//  UIColor+ThemeModule.h
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKThemeManager.h"

@interface UIColor (ThemeModule)


+(UIColor*)theme_color_main;
+(UIColor*)theme_color_mainalpha;

+(UIColor*)theme_color_mainhalf;
+(UIColor*)theme_color_purple;
+(UIColor*)theme_color_blue;
+(UIColor*)theme_color_green;
+(UIColor*)theme_color_yellow;
+(UIColor*)theme_color_red;


+(UIColor*)theme_nav_backgroundColor;
+(UIColor*)theme_nav_tintColor ;
+(UIColor*)theme_nav_titleColor;
   

+(UIColor*)theme_tabbar_backgroundColor;
+(UIColor*)theme_tabbar_tintColor;


+(UIColor*)theme_table_cellColor;
+(UIColor*)theme_table_cellSelectedColor;
+(UIColor*)theme_table_iconColor;
+(UIColor*)theme_table_cellSeparatorColor;
+(UIColor*)theme_table_subtitleColor;
+(UIColor*)theme_table_titleColor;

+(UIColor*)theme_vc_backgroundColor;
+(UIColor*)theme_vc_contentSubtitleColor;
+(UIColor*)theme_vc_contentTitleColor;
+(UIColor*)theme_vc_contentViewColor;
+(UIColor*)theme_vc_inputPlaceholderColor;
+(UIColor*)theme_vc_inputTextColor;

+(UIColor*)theme_news_table_cellDescFontColor;
+(UIColor*)theme_news_table_cellTitleFontColor;

@end
