//
//  ReaderEngineThemeFactory.m
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "ReaderEngineThemeFactory.h"

@interface ReaderEngineThemeFactory()
{
    NSArray* _themes;
}
@end

@implementation ReaderEngineThemeFactory

SINGLETON_IMPL(ReaderEngineThemeFactory)

-(id)init
{
    if(self = [super init]){
        [self setupThemes];
    }
    return self;
}

-(void)setupThemes
{
    
    _themes = @[
  @{@"bg":@"day_mode_bg",@"color":@"#000000",@"otherColor":@"#91846A",@"name":@"默认"},//AKReaderThemeDay //白色
  @{@"bg":@"parchment_mode_bg",@"color":@"#000000",@"otherColor":@"#91846A",@"name":@"羊皮纸"},//AKReaderThemeParchement //羊皮纸
  @{@"bg":@"water_mode_bg",@"color":@"#000000",@"otherColor":@"#736F83",@"name":@"水波纹"},//AKReaderThemeWater,  //水波纹
  @{@"bg":@"yellow_mode_bg",@"color":@"#000000",@"otherColor":@"#79684A",@"name":@"黄色"},//AKReaderThemeYellow,  //黄色
  @{@"bg":@"green_mode_bg",@"color":@"#000000",@"otherColor":@"#819381",@"name":@"绿色"},//AKReaderThemeGreen,//绿色
  @{@"bg":@"sheepskin_mode_bg",@"color":@"#000000",@"otherColor":@"#91846A",@"name":@"古装"},//AKReaderThemeSheepskin羊皮纸2
  @{@"bg":@"violet_mode_bg",@"color":@"#000000",@"otherColor":@"#91846A",@"name":@"紫色"},//AKReaderThemeViolet,        //紫色
  @{@"bg":@"pink_mode_bg",@"color":@"#000000",@"otherColor":@"#8A8592",@"name":@"粉色"},//AKReaderThemePink,          //粉色
  @{@"bg":@"lightGreen_mode_bg",@"color":@"#000000",@"otherColor":@"#928B98",@"name":@"浅绿色"},//AKReaderThemeLightGreen 护眼色
  @{@"bg":@"lightPink_mode_bg",@"color":@"#000000",@"otherColor":@"#80876B",@"name":@"浅粉色"},//AKReaderThemeLightPink //浅粉色
  @{@"bg":@"coffee_mode_bg",@"color":@"#95938F",@"otherColor":@"#6F6C68",@"name":@"咖啡色"},//AKReaderThemeCoffee,//咖啡色
  @{@"bg":@"blackGreen_mode_bg",@"color":@"#627079",@"otherColor":@"#3B4E57",@"name":@"黑色"}//AKReaderThemeBlackGreen黑色

                ];
}

-(NSArray*)getThemes
{
    return _themes;
}

-(NSDictionary*)getTheme:(AKReaderTheme)theme
{
    if(theme >= [_themes count]){
        return nil;
    }
    return [_themes objectAtIndex:theme];
}
@end
