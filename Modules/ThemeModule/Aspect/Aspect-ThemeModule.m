//
//  Aspect-ThemeModule.m
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect-ThemeModule.h"
#import "AKThemeManager.h"

@implementation Aspect_ThemeModule
+(void)load
{
   NSMutableDictionary* dic = [AKThemeManager  getThemesPath];
    NSLog(@"%@",dic);
    id value = [AKThemeManager getColor:@"news" withSubModule:AK_THEME_TABLE withKey:@"separatorColor"];
    NSLog(@"%@",value);
    
}
@end
