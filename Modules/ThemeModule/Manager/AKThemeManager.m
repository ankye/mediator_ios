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


@end
