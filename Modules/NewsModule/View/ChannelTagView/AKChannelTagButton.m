//
//  WYLabelButton.m
//  WYNews
//
//  Created by dai.fengyi on 15/6/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "AKChannelTagButton.h"

@implementation AKChannelTagButton
{
    UIImageView *_delete;
}
- (instancetype)initWithFrame:(CGRect)frame withChannel:(AKNewsChannel*)channel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channel = channel;
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{

    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.frame = (CGRect){self.frame.origin, CGSizeMake(kButtonW, kButtonH)};
    
    [self setBackgroundImage:[UIImage imageNamed:@"channel_grid_circle"] forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    _delete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_edit_delete"]];
    _delete.bounds = CGRectMake(0, 0, 15, 15);
    _delete.center = CGPointMake(6, 6);
    _delete.hidden = YES;
    [self addSubview:_delete];
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    if (_edit == NO || _channel.fixed == YES) {
        _delete.hidden = YES;
        
    }else {
        _delete.hidden = NO;
        
    }
}


@end
