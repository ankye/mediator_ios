//
//  AKBasePopupView.m
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBasePopupView.h"

@implementation AKBasePopupView

//竖屏大小
-(CGSize)portraitSize
{
    return CGSizeMake(SCREEN_WIDTH*0.7f, SCREEN_HEIGHT*0.4f);
}
//横屏大小
-(CGSize)landscapeSize
{
    return CGSizeMake(SCREEN_HEIGHT*0.7f, SCREEN_WIDTH*0.4f);
}

-(BOOL) isFullScreen
{
    return NO;
}

/**
 加载数据
 
 @param data 数据
 */
-(void)loadData:(NSObject*)data
{
    
}

@end
