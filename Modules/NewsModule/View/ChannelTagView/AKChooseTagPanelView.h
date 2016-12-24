//
//  WYButtonChooseView.h
//  WYNews
//
//  Created by dai.fengyi on 15/6/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKChannelTagButton.h"

#define kMarginH            10
#define kCountOfARow        4
#define kMarginW            ([UIScreen mainScreen].bounds.size.width - 4 *kButtonW) / 5
#define kDuration       0.5f

@class AKChooseTagPanelView;

@protocol LabelChooseDelegate <NSObject>
- (void)didSelectedButton:(AKChannelTagButton *)button;
- (void)didSetEditable:(AKChooseTagPanelView *)chooseView;
@end


@interface AKChooseTagPanelView : UIScrollView
@property (weak, nonatomic) id<LabelChooseDelegate> chooseDelegate;
//@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (assign, nonatomic, getter = isEdit) BOOL edit;
@property (assign, nonatomic, getter=isDragable) BOOL dragable;


- (void)addButtonWith:(AKNewsChannel *)channel position:(CGPoint)originPoint;

- (void)removeButton:(UIButton *)button;


- (void)refreshView;//should be public ?

-(NSMutableArray*)getChannels;


@end
