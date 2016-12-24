//
//  XTColorFetcher.m
//  pro
//
//  Created by TuTu on 16/8/16.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "XTColorFetcher.h"
#import "XTJson.h"
#import "UIColor+HexString.h"

@implementation XTColorFetcher

+ (NSDictionary *)getPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"xtAllColorsList" ofType:@"plist"] ;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] ;
    return data ;
}

+ (UIColor *)getColorWithRed:(float)fRed
                       green:(float)fGreen
                        Blue:(float)fBlue
{
    return [self getColorWithRed:fRed
                           green:fGreen
                            Blue:fBlue
                           alpha:1.0] ;
}

+ (UIColor *)getColorWithRed:(float)fRed
                       green:(float)fGreen
                        Blue:(float)fBlue
                       alpha:(float)alpha
{
    return [UIColor colorWithRed:((float) fRed / 255.0f)
                           green:((float) fGreen / 255.0f)
                            blue:((float) fBlue / 255.0f)
                           alpha:alpha] ;
}

+ (UIColor *)xt_colorWithKey:(NSString *)key
{
    NSString *jsonStr = [[[XTColorFetcher class] getPlist] objectForKey:key] ;
    if ([jsonStr containsString:@"["])
    {
        NSArray *colorValList = [XTJson getJsonObj:jsonStr] ;
        if (colorValList.count == 3)
        {
            return [[XTColorFetcher class] getColorWithRed:[colorValList[0] floatValue]
                                                     green:[colorValList[1] floatValue]
                                                      Blue:[colorValList[2] floatValue]] ;
        }
        else if (colorValList.count == 4)
        {
            return [[XTColorFetcher class] getColorWithRed:[colorValList[0] floatValue]
                                                     green:[colorValList[1] floatValue]
                                                      Blue:[colorValList[2] floatValue]
                                                     alpha:[colorValList[3] floatValue]] ;
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
    
    return nil ;
}



@end
