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
//子块key
#define AK_THEME_STATUSBAR          @"statusbar"
#define AK_THEME_COLOR              @"color"
#define AK_THEME_NAV                @"nav"
#define AK_THEME_TABLE              @"table"
#define AK_THEME_VC                 @"vc"
#define AK_THEME_TABBAR             @"tabbar"


@interface AKThemeManager : NSObject

+(NSMutableDictionary*)getThemesPath;

+(NSDictionary*)getThemePlist:(NSDictionary*)theme;

+(id)getThemeValue:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

+(UIColor*)getColor:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

+(UIImage*)getImage:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key;

@end
