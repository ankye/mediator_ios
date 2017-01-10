//
//  AKRequestManager+WallpaperModule.m
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKRequestManager+WallpaperModule.h"
#import "AKWallpaperContentListAPI.h"

@implementation AKRequestManager (WallpaperModule)


-(BOOL)wallpaper_requestContentListWithNum:(NSInteger)num success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    AKWallpaperContentListAPI *api = [[AKWallpaperContentListAPI alloc] initWithPageSize:num];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
    
    return YES;
}
@end
