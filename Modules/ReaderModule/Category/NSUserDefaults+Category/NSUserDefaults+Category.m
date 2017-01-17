//
//  NSUserDefaults+Category.m
//  powerlife
//
//  Created by 陈行 on 16/5/25.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "NSUserDefaults+Category.h"

#define EDITOR_IMAGE_PATH @"USER_DEFAULTS_EDITOR_IMAGE_PATH"

@implementation NSUserDefaults (Category)

+ (void)addEditorImagePath:(NSString *)imagePath{
    if (imagePath==nil || imagePath.length==0) {
        return;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * array = [userDefaults objectForKey:EDITOR_IMAGE_PATH];
    array = [NSMutableArray arrayWithArray:array];
    
    [array addObject:imagePath];
    [userDefaults setObject:array forKey:EDITOR_IMAGE_PATH];
    [userDefaults synchronize];
}

+ (NSArray *)editorImagePathList{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userDefaults objectForKey:EDITOR_IMAGE_PATH];
    if (array && array.count) {
        return array;
    }else{
        return nil;
    }
}

+ (void)removeEditorImagePath{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:EDITOR_IMAGE_PATH];
}

@end
