//
//  AKTableViewCell.m
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKTableViewCell.h"

@implementation AKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
