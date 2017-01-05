//
//  AKThemeManager+HSelectionList.m
//  Project
//
//  Created by ankye on 2016/12/30.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKThemeManager+HSelectionList.h"

@implementation AKThemeManager (HSelectionList)

#pragma mark theme hselectionlist
+(UIColor*)theme_hselectionlist_backgroundColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"backgroundColor"];

}
+(UIColor*)theme_hselectionlist_indicatorColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"indicatorColor"];
}
+(UIColor*)theme_hselectionlist_normalTitleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"normalTitleColor"];
}
+(NSInteger)theme_hselectionlist_normalTitleFontSize
{
    NSNumber* fontsize = [AKThemeManager getThemeValue:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"normalTitleFontSize"];
    return [fontsize integerValue];
}

+(UIColor*)theme_hselectionlist_selectedTitleColor
{
    return [AKThemeManager getColor:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"selectedTitleColor"];
}
+(NSInteger)theme_hselectionlist_selectedTitleFontSize
{
    NSNumber* fontsize = [AKThemeManager getThemeValue:AK_THEME_MODULE_COMPONENT withSubModule:AK_THEME_HSELECTIONLIST withKey:@"selectedTitleFontSize"];
    return [fontsize integerValue];
}


@end
