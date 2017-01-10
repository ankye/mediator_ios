//
//  AKRequestManager+WallpaperModule.h
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@interface AKRequestManager (WallpaperModule)

//请求信息
-(BOOL)wallpaper_requestContentListWithNum:(NSInteger)num success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure;

@end
