//
//  AKCollectionViewCell.m
//  Project
//
//  Created by ankye on 2016/12/28.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKCollectionViewCell.h"

@implementation AKCollectionViewCell


-(id)init
{
    self = [super init];
    if(self){
        [self registerThemeObserver];
    }
    return self;
}

#pragma mark AKThemeProtocol
-(void)configureViews
{
    self.backgroundView.backgroundColor = [AKThemeManager theme_table_cellBackgroundColor];
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

-(void)dealloc
{
    [self unregisterThemeObserver];
}


@end
