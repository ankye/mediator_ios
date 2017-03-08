//
//  AKLanguageHelper.m
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKLanguageHelper.h"

@interface AKLanguageHelper()
{
    NSString* _simplifiedStr;
    NSString* _traditionalStr;
    
}
@end

@implementation AKLanguageHelper

SINGLETON_IMPL(AKLanguageHelper)


/**
 简体转化为繁体

 @param string 简体字符串
 @return 繁体字符串
 */
- (NSString *)transformToTraditionalWith:(NSString *)string {
    NSMutableString *mutableStr = string.mutableCopy;
    NSInteger length = [string length];
    for (NSInteger i = 0; i< length; i++) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange gbRange = [self.simplifiedStr rangeOfString:str];
        if(gbRange.location != NSNotFound) {
            NSString *tString = [self.traditionalStr substringWithRange:gbRange];
            [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:tString];
        }
    }
    return mutableStr.copy;
}

- (NSString *)simplifiedStr {
    if (!_simplifiedStr) {
        _simplifiedStr =  [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"simplified" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        
    }
    return _simplifiedStr;
}

- (NSString *)traditionalStr {
    if (!_traditionalStr) {
        _traditionalStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"traditional" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return _traditionalStr;
}

@end
