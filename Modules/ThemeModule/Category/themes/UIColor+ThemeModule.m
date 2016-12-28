//
//  UIColor+ThemeModule.m
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "UIColor+ThemeModule.h"

@implementation UIColor (ThemeModule)

+(UIColor*)theme_color_main
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"main"];
}

+(UIColor*)theme_color_mainalpha
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"mainalpha"];
}

+(UIColor*)theme_color_mainhalf
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"mainhalf"];
}


+(UIColor*)theme_color_purple
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"purple"];
}

+(UIColor*)theme_color_blue
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"blue"];
}

+(UIColor*)theme_color_green
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"green"];
}

+(UIColor*)theme_color_yellow
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"yellow"];
}

+(UIColor*)theme_color_red
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_COLOR withKey:@"red"];
}

+(NSInteger)theme_statusBarStyle
{
    return [[AKThemeManager getThemeValue:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_STATUSBAR withKey:@"statusBarStyle"] integerValue];
}


+(UIColor*)theme_nav_backgroundColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_NAV withKey:@"backgroundColor"];
}
+(UIColor*)theme_nav_tintColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_NAV withKey:@"tintColor"];
}
+(UIColor*)theme_nav_titleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_NAV withKey:@"titleColor"];
}


+(UIColor*)theme_tabbar_backgroundColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABBAR withKey:@"backgroundColor"];
}

+(UIColor*)theme_tabbar_tintColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABBAR withKey:@"tintColor"];
}


+(UIColor*)theme_table_cellColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellColor"];
}

+(UIColor*)theme_table_cellSelectedColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellSelectedColor"];
}

+(UIColor*)theme_table_iconColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"iconColor"];
}

+(UIColor*)theme_table_cellSeparatorColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellSeparatorColor"];
}

+(UIColor*)theme_table_subtitleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"subtitleColor"];
}

+(UIColor*)theme_table_titleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"titleColor"];
}


+(UIColor*)theme_vc_backgroundColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"backgroundColor"];
}

+(UIColor*)theme_vc_contentSubtitleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"contentSubtitleColor"];
}

+(UIColor*)theme_vc_contentTitleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"contentTitleColor"];
}

+(UIColor*)theme_vc_contentViewColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"contentViewColor"];
}

+(UIColor*)theme_vc_inputPlaceholderColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"inputPlaceholderColor"];
}

+(UIColor*)theme_vc_inputTextColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_VC withKey:@"inputTextColor"];
}

+(UIColor*)theme_news_table_cellDescFontColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellDescFontColor"];
}

+(UIColor*)theme_news_table_cellTitleFontColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellTitleFontColor"];
}

@end
