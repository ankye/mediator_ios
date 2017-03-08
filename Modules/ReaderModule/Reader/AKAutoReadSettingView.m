//
//  AKAutoReadSettingView.m
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKAutoReadSettingView.h"

#import <BButton/BButton.h>

@interface AKAutoReadSettingView()
{
    BButton *_coverPatterns ;
    BButton *_scrollMode;
}

@end

@implementation AKAutoReadSettingView

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    BButton *speedSubtract                = [[BButton alloc] initWithFrame:CGRectMake(10, 10, 112, 40) type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    
    [speedSubtract setTitle:@"速度" forState:UIControlStateNormal];
    [speedSubtract addAwesomeIcon:FABackward beforeTitle:YES];
    speedSubtract.tag                      = 800;
    [speedSubtract addTarget:self action:@selector(tapClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:speedSubtract];
    
    
    BButton *speedAdd = [[BButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 122, 10, 112, 40) type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [speedAdd setTitle:@"速度" forState:UIControlStateNormal];
    [speedAdd addAwesomeIcon:FAForward beforeTitle:NO];
    speedAdd.tag                           = 801;
    [speedAdd addTarget:self action:@selector(tapClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:speedAdd];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self addSubview:line];
    
    AKLabel* label = [[AKLabel alloc] initWithFrame:CGRectMake(10, 70, 120, 40)];
    [label setText:@"翻页方式设置 "];
    [label setTextColor:[UIColor whiteColor]];
    [self addSubview:label];
    
    _coverPatterns                = [[BButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110-110, 70, 90, 40) type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [_coverPatterns setTitle:@"覆盖模式" forState:UIControlStateNormal];
 
    [_coverPatterns addTarget:self action:@selector(tapClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _coverPatterns.tag                      = 802;
    [self addSubview:_coverPatterns];
    
    _scrollMode                   = [[BButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 70, 90, 40) type:BButtonTypeDefault style:BButtonStyleBootstrapV3];
    [_scrollMode setTitle:@"滚动模式" forState:UIControlStateNormal];
    [_scrollMode addTarget:self action:@selector(tapClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _scrollMode.tag                         = 803;
    [self addSubview:_scrollMode];
    
    BButton *stopButton                   = [[BButton alloc] initWithFrame:CGRectMake(0, 136, SCREEN_WIDTH, 44) type:BButtonTypeDanger style:BButtonStyleBootstrapV3];
    [stopButton setTitle:@"退出自动阅读" forState:UIControlStateNormal];
    stopButton.tag = 804;
    [stopButton addTarget:self action:@selector(tapClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stopButton];
}

-(void)selectedButton:(int)type
{
    if(type == 1){
        [_coverPatterns setType:BButtonTypeInfo];
        [_scrollMode setType:BButtonTypeDefault];
    }else{
        [_coverPatterns setType:BButtonTypeDefault];
        [_scrollMode setType:BButtonTypeInfo];
    }
}

-(void)tapClickBtn:(UIButton*)btn
{
    if(self.settingTapAction){
        self.settingTapAction(btn.tag);
    }
    
}

@end
