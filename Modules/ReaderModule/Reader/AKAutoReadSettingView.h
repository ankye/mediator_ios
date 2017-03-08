//
//  AKAutoReadSettingView.h
//  Project
//
//  Created by ankye sheng on 2017/3/7.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKView.h"

@interface AKAutoReadSettingView : AKView

@property (copy, nonatomic) void(^settingTapAction)(NSInteger);

-(void)selectedButton:(int)type;

@end
