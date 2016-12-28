//
//  UINavigationBar+ThemeModule.m
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "UINavigationBar+ThemeModule.h"

@implementation UINavigationBar (ThemeModule)

- (void)addThemeManager
{
    [self configureViews];
    [self registerThemeObserver];
}

#pragma mark
#pragma mark - ThemeManager
- (void)configureViews
{
    // set the background of navigationbar
    self.barTintColor = [UIColor theme_nav_tintColor];
}

- (void)registerThemeObserver
{
  
    [AK_SIGNAL_MANAGER.onThemeChange addObserver:self callback:^(id  _Nonnull self) {
        [self configureViews];
    }];
}

- (void)unregisterThemeObserver
{
    [AK_SIGNAL_MANAGER.onThemeChange removeObserver:self];
}


@end
