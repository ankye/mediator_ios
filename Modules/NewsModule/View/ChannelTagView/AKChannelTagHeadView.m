//
//  AKChannelTagHeadView.m
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKChannelTagHeadView.h"




@implementation AKChannelTagHeadView

-(id)init
{
    self = [super init];
    if(self){
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"我的频道";
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 36));
        make.centerY.equalTo(self);
    }];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.font = [UIFont systemFontOfSize:10];
    _tipsLabel.text = @"长按拖曳可以排序";
    _tipsLabel.textColor = [UIColor grayColor];
    [self addSubview:_tipsLabel];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 36));
        make.centerY.equalTo(self);
    }];
    [_tipsLabel setHidden:YES];
    
    _button = [[UIButton alloc] init];
    [_button setTitle:@"编辑" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_button setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_bg"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_selected_bg"] forState:UIControlStateHighlighted];
    [self addSubview:_button];

    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.centerY.equalTo(self);
    }];
    [_button setHidden:YES];
}

@end
