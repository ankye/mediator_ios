//
//  AKReaderSetting.m
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKReaderSetting.h"
#import "ReaderEngineThemeFactory.h"

@interface AKReaderSetting ()


@property (strong, nonatomic) UIImage *themeImage;
@property (strong, nonatomic) NSArray *themeImageArr;


@end


@implementation AKReaderSetting

SINGLETON_IMPL(AKReaderSetting)

-(id)init
{
    if(self = [super init]){
        
        _fontSize = 22;
        _fontName = @"HelveticaNeue";         //字体
        _isTraditional = NO;   //是否繁体
        _lineSpaceType = AKPagingLineSpaceTypeNormal;  //行间距
        _pageStyle = TheSimulationEffectOfPage; //翻页动画
        _isNightMode = NO;     //是否夜间模式

        [self selectdTheme:AKReaderThemeDay];
        
    }
    return self;
}

-(void)selectdTheme:(AKReaderTheme)theme
{
    _theme = theme;  //主题设置
    NSDictionary* themeDic = [[ReaderEngineThemeFactory sharedInstance] getTheme:theme];
    _textColor = [UIColor colorWithHexString:themeDic[@"color"]];
    _otherTextColor = [UIColor colorWithHexString:themeDic[@"otherColor"]];//其他如标题,电池,时间等
    _themeImage = [self getThemeImageWith:self.theme];
   

}
- (UIImage *)themeImage {
    if (!_themeImage) {
        _themeImage = [self getThemeImageWith:self.theme];
    }
    return _themeImage;
}

- (UIImage *)getThemeImageWith:(AKReaderTheme)theme {
    if (self.isNightMode) {
        
    }
    NSDictionary* dic = [[ReaderEngineThemeFactory sharedInstance] getTheme:theme];
    if(dic){
        return [UIImage imageNamed:dic[@"bg"]];
    }else{
        return nil;
    }
}

@end
