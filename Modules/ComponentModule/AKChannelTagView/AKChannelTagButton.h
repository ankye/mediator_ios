//
//  WYLabelButton.h
//  WYNews
//
//  Created by dai.fengyi on 15/6/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKNewsChannel.h"

#define kButtonW    70
#define kButtonH    40

@interface AKChannelTagButton : AKButton

@property (assign, nonatomic, getter = isEdit) BOOL edit;
@property (strong,nonatomic) AKNewsChannel* channel;

- (instancetype)initWithFrame:(CGRect)frame withChannel:(AKNewsChannel*)channel;

@end
