//
//  AutomaticReadingViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/13.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "AutomaticReadingViewController.h"
#import "CoverPatternsViewController.h"
#import "ScrollModeViewController.h"

@interface AutomaticReadingViewController ()<CoverPatternsViewControllerDelegate,ScrollModeViewControllerDelegate>

@end

@implementation AutomaticReadingViewController {
    BOOL                        _isShowMenu; // 是否显示菜单
    UITapGestureRecognizer      *_tapGestureRecognizer; // 控制菜单是否显示
    CoverPatternsViewController *_coverPatternsViewController; // 覆盖翻页模式
    ScrollModeViewController    *_scrollModeViewController; // 滚动翻页模式
    
}

#pragma mark - 类方法
+ (AutomaticReadingViewController *)shareAutomaticReadingViewController:(UIViewController *)currentViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight automaticReadingTypes:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed {
    
    AutomaticReadingViewController *automaticReadingViewController = [[AutomaticReadingViewController alloc] init];
    automaticReadingViewController.currentViewController           = currentViewController;
    automaticReadingViewController.topHeight                       = topHeight;
    automaticReadingViewController.bottomHeight                    = bottomHeight;
    automaticReadingViewController.speed                           = speed;
    automaticReadingViewController.automaticReadingTypes           = automaticReadingTypes;
    
    return automaticReadingViewController;
}

#pragma mark - 对外方法
- (void)refreshViewController {
    // 添加点击手势，管理菜单
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerClick)];
        [self.view addGestureRecognizer:_tapGestureRecognizer];
    }
    [self automaticReadingModel:self.automaticReadingTypes];
}
#pragma mark - 设置自动阅读速度
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
    [_coverPatternsViewController automaticReadingSpeed:_speed];
    [_scrollModeViewController automaticReadingSpeed:_speed];
}
#pragma mark - 设置自动阅读模式
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes {
    // 从新设置下一页控制器内容
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    
    if (automaticReadingTypes == CoverPatterns) {
        [_scrollModeViewController.view removeFromSuperview];
        _scrollModeViewController = nil;
        if (_coverPatternsViewController) {
            return;
        }
        _coverPatternsViewController          = [[CoverPatternsViewController alloc] initWithCurrentViewController:self.currentViewController nextViewController:self.nextViewController topHeight:_topHeight bottomHeight:_bottomHeight speed:_speed];
        _coverPatternsViewController.delegate = self;
        [self.view addSubview:_coverPatternsViewController.view];
    } else {
        [_coverPatternsViewController.view removeFromSuperview];
        _coverPatternsViewController = nil;
        
        if (_scrollModeViewController) {
            return;
        }
        _scrollModeViewController = [[ScrollModeViewController alloc] initWithCurrentViewController:self.currentViewController nextViewController:self.nextViewController topHeight:_topHeight bottomHeight:_bottomHeight speed:_speed];
        _scrollModeViewController.delegate = self;
        [_scrollModeViewController initializeView];
        [self.view addSubview:_scrollModeViewController.view];
    }
}
#pragma mark - 暂定自动阅读
- (void)automaticStopReading {
    [_coverPatternsViewController automaticStopReading];
    [_scrollModeViewController automaticStopReading];
}

#pragma mark - 点击手势响应
- (void)tapGestureRecognizerClick {
    _isShowMenu = !_isShowMenu;
    if (_isShowMenu) {
        // 显示菜单，停止自动阅读
        [_coverPatternsViewController automaticStopReading];
        [_scrollModeViewController automaticStopReading];
    } else {
        // 收起菜单，继续自动阅读
        [_coverPatternsViewController continueAutomaticReading];
        [_scrollModeViewController continueAutomaticReading];
    }
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerIsShowMenu:)]) {
        [self.delegate AutomaticReadingViewControllerIsShowMenu:_isShowMenu];
    }
}

#pragma mark - CoverPatternsViewControllerDelegate 覆盖模式代理
#pragma mark 获取下一页
- (UIViewController *)CoverPatternsViewControllerNextViewController:(CoverPatternsViewController *)coverPatternsViewController {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    return self.nextViewController;
}
#pragma mark 退出自动翻页
- (void)CoverPatternsViewControllerExit {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerExit)]) {
        [self.delegate AutomaticReadingViewControllerExit];
    }
}

#pragma mark - 滚动模式代理
#pragma mark 获取下一页
- (UIViewController *)ScrollModeViewControllerNextViewController:(ScrollModeViewController *)scrollModeViewController {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerNextViewController:)]) {
        self.nextViewController = [self.delegate AutomaticReadingViewControllerNextViewController:self];
    }
    return self.nextViewController;
}
#pragma mark 退出自动阅读
- (void)ScrollModeViewControllerExit {
    if ([self.delegate respondsToSelector:@selector(AutomaticReadingViewControllerExit)]) {
        [self.delegate AutomaticReadingViewControllerExit];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
