//
//  CoverPatternsViewController.m
//  创新版
//
//  Created by XuPeng on 16/6/14.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "CoverPatternsViewController.h"

#define kAutomaticReadingSpeed         0.004f

@interface CoverPatternsViewController ()

@end

@implementation CoverPatternsViewController {
    UIViewController       *_currentViewController; // 放在下层的阅读页面
    UIViewController       *_nextViewController; // 放在上层的阅读页面
    CGFloat                _topHeight; // 顶部页眉高度
    CGFloat                _bottomHeight;// 底部页脚高度
    NSInteger              _speed; // 自动翻页速度
    NSTimer                *_timer; // 定时器
    UIImageView            *_nextImageView; // 上层阅读页面的截图
}

- (instancetype)initWithCurrentViewController:(UIViewController *)currentViewController nextViewController:(UIViewController *)nextViewController topHeight:(CGFloat)topHeight bottomHeight:(CGFloat)bottomHeight speed:(NSInteger)speed {
    self = [super init];
    if (self) {
        _currentViewController = currentViewController;
        _nextViewController    = nextViewController;
        _topHeight             = topHeight;
        _bottomHeight          = bottomHeight;
        _speed                 = speed;
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    // 1、绘制下层
    _currentViewController.view.userInteractionEnabled = NO;
    [self.view addSubview:_currentViewController.view];
    
    // 2、绘制上层
    [self drawUpperVeiw];
    
    // 3、定时器
    [self addTimer];
}

#pragma mark - 暂停自动阅读
- (void)automaticStopReading {
    NSLog(@"CoverPatternsViewController  删除定时器");
    [_timer invalidate];
}
#pragma mark - 恢复自动阅读
- (void)continueAutomaticReading {
    [self addTimer];
}
#pragma mark - 设置自动阅读速度
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
}
#pragma mark - 设置定时器
- (void)addTimer {
    NSLog(@"CoverPatternsViewController  设置定时器");
    _timer = [NSTimer scheduledTimerWithTimeInterval:(kAutomaticReadingSpeed / _speed )target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}
#pragma mark - 绘制上层view
- (void)drawUpperVeiw {
    if (_nextImageView) {
        [_nextImageView removeFromSuperview];
        _nextImageView = nil;
    }
    UIGraphicsBeginImageContextWithOptions(_nextViewController.view.frame.size, NO, 0.0);
    [_nextViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.frame = CGRectMake(0, 0, image.size.width, _topHeight);
    _nextImageView.backgroundColor = [UIColor colorWithPatternImage:image];
    // 添加阴影
    [[_nextImageView layer] setShadowOffset:CGSizeMake(0, 3)];
    [[_nextImageView layer] setShadowOpacity:1];
    [[_nextImageView layer] setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f].CGColor];
    [self.view addSubview:_nextImageView];
}
#pragma mark - 定时器执行方法
- (void)timerFired {
    // 截图向下移动
    CGRect nextImageViewRect = _nextImageView.frame;
    nextImageViewRect.size.height += 0.1f;
    _nextImageView.frame = nextImageViewRect;
    
    // 计算是否需要获取下一页
    if (nextImageViewRect.size.height + _bottomHeight >= _nextViewController.view.frame.size.height) {
        [self showNextPage];
    }
}
#pragma mark - 跳转到下一页
- (void)showNextPage {
    // 1、移除下层ViewController
    [_currentViewController.view removeFromSuperview];

    // 2、将上层ViewController变为下层
    _currentViewController                             = _nextViewController;
    _currentViewController.view.userInteractionEnabled = NO;
    [self.view addSubview:_currentViewController.view];
    
    // 3、获取下一页控制器
    if ([self.delegate respondsToSelector:@selector(CoverPatternsViewControllerNextViewController:)]) {
        _nextViewController = [self.delegate CoverPatternsViewControllerNextViewController:self];
    }
    if (!_nextViewController) {
        if ([self.delegate respondsToSelector:@selector(CoverPatternsViewControllerExit)]) {
            [self.delegate CoverPatternsViewControllerExit];
        }
    }
    // 4、_nextImageView 指向_nextViewController
    [self drawUpperVeiw];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
