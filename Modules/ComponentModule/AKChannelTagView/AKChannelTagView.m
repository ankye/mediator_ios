//
//  WYButtonChooseViewController.m
//  WYButtonChooseView
//
//  Created by dai.fengyi on 15/6/3.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "AKChannelTagView.h"
#import "AKChooseTagPanelView.h"
#import "AKNewsChannel.h"
#import "AKChannelTagHeadView.h"

#define kDockHeight 49
#define kHeaderHeight       36
#define kDefaultY           20
#define kTopicHeaderBgColor         [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]

//WYButtonChooseView
#define kButtonChooseViewSelectedTopicMaxCount  24


@interface AKChannelTagView () <LabelChooseDelegate>

@property (strong, nonatomic) AKChannelTagHeadView *topChooseHeaderView;
@property (strong, nonatomic) AKChooseTagPanelView *topChooseView;

@property (strong, nonatomic) AKChannelTagHeadView *bottomChooseHeaderView;
@property (strong, nonatomic) AKChooseTagPanelView *bottomChooseView;



@end

@implementation AKChannelTagView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews
{

    self.backgroundColor =kTopicHeaderBgColor;
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"chooseTagViewCloseBtn.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(doCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(28);
        make.right.equalTo(self).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _topChooseHeaderView = [[AKChannelTagHeadView alloc] init];
    _topChooseHeaderView.backgroundColor = kTopicHeaderBgColor;
    [self addSubview:_topChooseHeaderView];
    [_topChooseHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeBtn).mas_offset(28);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kHeaderHeight);
    }];
    
 
    [_topChooseHeaderView.button setHidden:NO];
    [_topChooseHeaderView.titleLabel setText:@"我的频道"];
    [_topChooseHeaderView.tipsLabel setHidden:NO];

    [_topChooseHeaderView.button addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _topChooseView = [[AKChooseTagPanelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topChooseHeaderView.frame), [UIScreen mainScreen].bounds.size.width, 200)];
    _topChooseView.chooseDelegate = self;
    _topChooseView.dragable = YES;
    [self addSubview:_topChooseView];
    [_topChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topChooseHeaderView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    _bottomChooseHeaderView = [[AKChannelTagHeadView alloc] init];
    _bottomChooseHeaderView.backgroundColor = kTopicHeaderBgColor;
    [self addSubview:_bottomChooseHeaderView];
    [_topChooseHeaderView.titleLabel setText:@"推荐频道"];
    


    [_bottomChooseHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topChooseView.mas_bottom).mas_offset(20);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kHeaderHeight);
    }];
    
    
    _bottomChooseView = [[AKChooseTagPanelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomChooseHeaderView.frame), [UIScreen mainScreen].bounds.size.width, 200)];
    _bottomChooseView.chooseDelegate = self;
    _bottomChooseView.dragable = NO;
    [self addSubview:_bottomChooseView];
    
    [_bottomChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomChooseHeaderView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(200);
    }];

}


- (void)refreshView
{
    [_topChooseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_topChooseView.contentSize.height);
    }];
    [_bottomChooseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_bottomChooseView.contentSize.height);
    }];
//
//    [self setNeedsLayout];
//
//    [UIView animateWithDuration:kDuration animations:^{
//        _topChooseView.frame = CGRectMake(0, CGRectGetMaxY(_header.frame), _topChooseView.contentSize.width, _topChooseView.contentSize.height);
//        _bottomChooseView.frame = CGRectMake(0, CGRectGetMaxY(_label.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_label.frame));
//    }];
}
#pragma mark - button Action
- (void)switchAction:(UIButton *)sender
{
   
    [self doSwitchAction:_topChooseView.edit];
}

-(void)doSwitchAction:(BOOL)flag
{
    if(flag){
        _topChooseView.edit = NO;
        [_topChooseHeaderView.button setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        _topChooseView.edit = YES;
        [_topChooseHeaderView.button setTitle:@"完成" forState:UIControlStateNormal];
    }
}

- (void)doCloseAction:(UIButton *)sender
{
    //1. 更新UI上作所改动至数组
   // [self refreshData];
    [UIView animateWithDuration:kDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    self.onClose(@{@"selected":[_topChooseView getChannels],@"unSelected":[_bottomChooseView getChannels]});
    //2. 通知topicDelegate数据改动
   // [self.topicDelegate buttonChooseViewTopicArrayDidChange:_selectedArray];
}


#pragma mark - ChooseButtonView delegate
- (void)didSelectedButton:(AKChannelTagButton *)button
{
    if (button.superview == _topChooseView) {
        //收起并跳转到该栏目新闻
        if (button.isEdit ) {//编辑状态
            if(button.channel.fixed == NO){
                [_bottomChooseView addButtonWith:button.channel position:[_bottomChooseView convertPoint:button.frame.origin fromView:_topChooseView]];
                [_topChooseView removeButton:button];
            }
        } else {//非编辑状态
            //1. 收view
            
             self.onClick(1,@{@"click":button.titleLabel.text});
            
            [self doCloseAction:nil];
            //2. 通知topicDelegate所选
            //[self.topicDelegate buttonChooseViewDidSelected:button.titleLabel.text];
           
        }
    }else {
        if (_topChooseView.buttonArray.count < kButtonChooseViewSelectedTopicMaxCount) {
            
            [_topChooseView addButtonWith:button.channel position:[_topChooseView convertPoint:button.frame.origin fromView:_bottomChooseView]];
            [_bottomChooseView removeButton:button];
        }else {
            [AKPopupManager showErrorTips:@"已经加满了"];
            return;
        }
    }
    [self refreshView];
}

- (void)didSetEditable:(id)chooseView
{
    [self doSwitchAction:NO];
}

-(void)loadData:(NSObject *)data
{
    NSDictionary* dic = (NSDictionary*)data;
    NSMutableArray* selectedArray = dic[@"selected"];
    NSMutableArray* unSelectedArray = dic[@"unSelected"];
  
    for (AKNewsChannel *channel in selectedArray) {
        [_topChooseView addButtonWith:channel position:CGPointZero];
    }
    
    for (AKNewsChannel *channel in unSelectedArray) {
        [_bottomChooseView addButtonWith:channel position:CGPointZero];
    }

    //在加入到view中才知道view.frame,之前在refreshView中的self.frame是满屏尺寸
    [self refreshView];

}

@end
