//
//  AKThemeManager.h
//  Project
//
//  Created by ankye on 2016/12/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

// 皮肤路径
#define APP_THEMES_PATH             @"AKThemes"
#define CUSTOM_THEMES_PATH          @"Themes"
//主题模块KEY
#define AK_THEME_MODULE_GENERAL     @"general"
#define AK_THEME_MODULE_COMPONENT   @"component"
//子块key
#define AK_THEME_STATUSBAR          @"statusbar"
#define AK_THEME_COLOR              @"color"
#define AK_THEME_NAV                @"nav"
#define AK_THEME_TABLE              @"table"
#define AK_THEME_VC                 @"vc"
#define AK_THEME_TABBAR             @"tabbar"
#define AK_THEME_HSELECTIONLIST     @"hselectionlist"

@interface AKThemeManager : NSObject

+(NSMutableDictionary*)getThemesPath;

+(NSDictionary*)getThemePlist:(NSDictionary*)theme;

+(id)getThemeValue:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

+(UIColor*)getColor:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

+(UIImage*)getImage:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

#pragma mark theme color
+(UIColor*)theme_color_main;
+(UIColor*)theme_color_mainalpha;

+(UIColor*)theme_color_mainhalf;
+(UIColor*)theme_color_purple;
+(UIColor*)theme_color_blue;
+(UIColor*)theme_color_green;
+(UIColor*)theme_color_yellow;
+(UIColor*)theme_color_red;

#pragma mark theme nav
+(UIColor*)theme_nav_backgroundColor;
+(UIColor*)theme_nav_tintColor ;
+(UIColor*)theme_nav_titleColor;

#pragma mark theme tabbar
+(UIColor*)theme_tabbar_backgroundColor;
+(UIColor*)theme_tabbar_tintColor;

#pragma mark theme table
+(UIColor*)theme_table_cellBackgroundColor;
+(UIColor*)theme_table_cellTextColor;
+(UIColor*)theme_table_cellSelectedColor;
+(UIColor*)theme_table_iconColor;
+(UIColor*)theme_table_cellSeparatorColor;
+(UIColor*)theme_table_subtitleColor;
+(UIColor*)theme_table_titleColor;
+(NSInteger)theme_table_cellTextFontSize;

#pragma mark theme vc
+(UIColor*)theme_vc_backgroundColor;
+(UIColor*)theme_vc_contentSubtitleColor;
+(UIColor*)theme_vc_contentTitleColor;
+(UIColor*)theme_vc_contentViewColor;
+(UIColor*)theme_vc_inputPlaceholderColor;
+(UIColor*)theme_vc_inputTextColor;
#pragma mark theme news table
+(UIColor*)theme_news_table_cellDescFontColor;
+(UIColor*)theme_news_table_cellTitleFontColor;


@end
