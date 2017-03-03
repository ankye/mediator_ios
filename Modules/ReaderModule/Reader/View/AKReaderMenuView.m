//
//  AKReaderMenuView.m
//  Project
//
//  Created by ankye on 2017/2/24.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKReaderMenuView.h"
#import "YBottomButton.h"

@implementation AKReaderMenuView

- (id) init
{
    self = [super init];
    if(self){
        [self setupViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
    }
    return self;
}

- (void) setupViews
{
    _topbarView = [[AKView alloc] init];
    _bottomBarView = [[AKView alloc] init];
    
    _topbarView.backgroundColor = [UIColor grayColor];
    _bottomBarView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_topbarView];
    [self addSubview:_bottomBarView];
    
    [_topbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    [_bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    self.userInteractionEnabled = YES;
    
    [self setupTopBarViews];
    [self setupBottomBarViews];
    
}


-(void)setupTopBarViews
{
    
}

-(void)setupBottomBarViews
{
    _bottomBarView.userInteractionEnabled = YES;
    NSArray *imgArr = @[@"night_mode",@"feedback",@"directory",@"preview_btn",@"reading_setting"];
    NSArray *titleArr = @[@"夜间",@"翻页",@"目录",@"缓存",@"设置"];
    __weak typeof(self) wself = self;
    void (^tapAction)(NSInteger) = ^(NSInteger tag){
        NSLog(@"tapAction %zi",tag);
        switch (tag) {
            case 200:           //日/夜间模式切换
                if (wself.menuTapAction) {
                    wself.menuTapAction(tag);
                }
                break;
            case 201:           //翻页
                if (wself.menuTapAction) {
                    wself.menuTapAction(tag);
                }
                break;
            case 202: {          //目录
                [wself hideMenuView];
                if (wself.menuTapAction) {
                    wself.menuTapAction(tag);
                }
            }
                break;
            case 203: {          //下载
               
            }
                break;
            case 204:           //设置
                
                break;
            default:
                break;
        }
    };
    for (NSInteger i = 0; i < imgArr.count; i++) {
        YBottomButton *btn = [YBottomButton bottonWith:titleArr[i] imageName:imgArr[i] tag:i];
        btn.tapAction = tapAction;
        [_bottomBarView addSubview:btn];
    }

}

- (void) showMenuView
{
    self.hidden = NO;
}
- (void) hideMenuView
{
    self.hidden = YES;
}

@end
