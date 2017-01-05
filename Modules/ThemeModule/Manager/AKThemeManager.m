//
//  AKThemeManager.m
//  Project
//
//  Created by ankye on 2016/12/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKThemeManager.h"

static NSMutableDictionary  *_themePaths;
static NSDictionary         *_currentTheme;

@implementation AKThemeManager



+(NSMutableDictionary*)getThemesPath
{
    if( _themePaths == nil){
        _themePaths = [[NSMutableDictionary alloc] init];
        [self getAppThemesPath:APP_THEMES_PATH isUserPath:NO];
        [self getAppThemesPath:CUSTOM_THEMES_PATH isUserPath:NO];
        [self getAppThemesPath:CUSTOM_THEMES_PATH isUserPath:YES];
    }
    
    return _themePaths;
}

+(BOOL)getAppThemesPath:(NSString*)dirName isUserPath:(BOOL)isUserPath
{
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dirName];
    if(isUserPath){
        path = [FileHelper getUserInfoPath:dirName];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    if(fileList && [fileList count] >0){
        for(NSInteger i=0; i< [fileList count] ; i++){
            NSString* name = fileList[i];
            _themePaths[name] = @{@"name":name,@"path":path,@"plist":@"theme.plist"};
        }
    }
    return YES;
}

+(NSDictionary*)getDefaultTheme
{
    NSArray* keys = [self getThemesPath].allKeys;
    if(keys && [keys count]> 0){
        NSDictionary* themePath = [[self getThemesPath] objectForKey:keys[0]];
        return [self getThemePlist:themePath];
    }
    return nil;
}

+(NSDictionary*)getTheme
{
    if(_currentTheme == nil){
        _currentTheme = [self getDefaultTheme];
    }
    return _currentTheme;
}

+(NSDictionary*)getThemePlist:(NSDictionary *)theme
{
    NSString* plistPath = [NSString stringWithFormat:@"%@/%@/%@",theme[@"path"],theme[@"name"],theme[@"plist"]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] ;
    return data ;
    
}

+(id)getThemeValue:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key
{
    NSDictionary* themeInfo = [self getTheme];
    id value = themeInfo[moduleName][moduleKey][key];
    if(!value){
        value = themeInfo[AK_THEME_MODULE_GENERAL][moduleKey][key];
    }
    return value;
}

+(UIColor*)getColor:(NSString*)moduleName withSubModule:(NSString*)moduleKey withKey:(NSString*)key
{
    NSString* jsonStr = [self getThemeValue:moduleName withSubModule:moduleKey withKey:key];
    if ([jsonStr containsString:@"["])
    {
        NSArray *colorValList = [AppHelper arrayWithData: [jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        if (colorValList.count == 3)
        {
           return [UIColor colorWithRed:[colorValList[0] floatValue]
                                  green:[colorValList[1] floatValue]
                                   blue:[colorValList[2] floatValue]
                                  alpha:1.0];
           
        }
        else if (colorValList.count == 4)
        {
            return [UIColor colorWithRed:[colorValList[0] floatValue]
                                   green:[colorValList[1] floatValue]
                                    blue:[colorValList[2] floatValue]
                                   alpha:[colorValList[3] floatValue]];
        }
    }
    else {
        if ([jsonStr containsString:@","]) {
            NSArray *list = [jsonStr componentsSeparatedByString:@","] ;
            return [UIColor colorWithHexString:[list firstObject] alpha:[[list lastObject] floatValue]] ;
        }
        else {
            return [UIColor colorWithHexString:jsonStr] ;
        }
    }

    return nil;
}

#pragma mark theme general

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

+(UIColor*)theme_table_cellBackgroundColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellBackgroundColor"];
}

+(UIColor*)theme_table_cellTextColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellTextColor"];
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

+(NSInteger) theme_table_cellTextFontSize
{
    NSNumber* size = [self getThemeValue:AK_THEME_MODULE_GENERAL withSubModule:AK_THEME_TABLE withKey:@"cellTextFontSize"];
    return [size integerValue];
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
