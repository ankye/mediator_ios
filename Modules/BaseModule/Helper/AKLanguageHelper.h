//
//  AKLanguageHelper.h
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKLanguageHelper : NSObject

SINGLETON_INTR(AKLanguageHelper)

/**
 简体转化为繁体
 
 @param string 简体字符串
 @return 繁体字符串
 */
- (NSString *)transformToTraditionalWith:(NSString *)string;


@end
