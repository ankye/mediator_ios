//
//  NSUserDefaults+Category.h
//  powerlife
//
//  Created by 陈行 on 16/5/25.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)

+ (void)addEditorImagePath:(NSString *)imagePath;

+ (NSArray *)editorImagePathList;

+ (void)removeEditorImagePath;

@end
