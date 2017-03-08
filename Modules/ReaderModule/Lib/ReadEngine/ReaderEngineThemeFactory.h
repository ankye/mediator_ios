//
//  AKReaderEngineThemeFactory.h
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadEngineDefine.h"

@interface ReaderEngineThemeFactory : NSObject

SINGLETON_INTR(ReaderEngineThemeFactory)

-(NSArray*)getThemes;

-(NSDictionary*)getTheme:(AKReaderTheme)theme;


@end
