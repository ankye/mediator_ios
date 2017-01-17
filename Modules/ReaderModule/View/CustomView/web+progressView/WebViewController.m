//
//  WebViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "WebViewController.h"
#import "CustomWebProgressView.h"
#import "CustomShareView.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"

@interface WebViewController ()

@property(nonatomic,weak)WKWebView * webView;

@property(nonatomic,weak)CustomWebProgressView * webProgressView;

@property (weak, nonatomic) CustomShareView * shareView;

@property(nonatomic,assign)BOOL isNavigationShow;
@property(nonatomic,copy)UIColor * oldNavBgColor;
@property(nonatomic,assign)UIStatusBarStyle statusBarStyle;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadNavicationBar];
    [self loadWebView];
    [self loadWebProgressView];
}

- (void)loadNavicationBar{
    self.navigationItem.title=self.titleName;
    
    UIBarButtonItem * lbbi=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousViewCon)];
    
    self.navigationItem.leftBarButtonItem=lbbi;
    
    if ((![OpenShare isQQInstalled] && ![OpenShare isWeiboInstalled] && ![OpenShare isWeixinInstalled]) || self.isHiddenShare){
        
    }else{
        UIBarButtonItem * rbbi = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareWebView)];
        self.navigationItem.rightBarButtonItem = rbbi;
    }
}

- (void)backToPreviousViewCon{
    [self.webProgressView freeWebProgressView];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webProgressView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareWebView{
    self.shareView.hidden=NO;
    [self.view bringSubviewToFront:self.shareView];
}

- (void)loadWebView{
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:webView];
    self.webView= webView;
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    [webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            if (self.titleName==nil) {
                self.navigationItem.title = self.webView.title;
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

- (void)loadWebProgressView{
    CustomWebProgressView * pv=[CustomWebProgressView progressViewAndFrame:CGRectMake(0, 64, WIDTH, 2) andWebView:self.webView andDelegate:nil];
    pv.backgroundColor=THEME_COLOR;
    [self.view addSubview:pv];
    self.webProgressView=pv;
}

- (CustomShareView *)shareView{
    if (_shareView==nil) {
        CustomShareView * shareView = [CustomShareView shareViewWithShareData:self.shareImage andDesc:self.shareDesc];
        shareView.shareUrl=self.requestUrl;
        [self.view addSubview:shareView];
        _shareView=shareView;
    }
    return _shareView;
}

#pragma mark - view代理
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=self.isNavigationShow;
    self.navigationController.navigationBar.barTintColor=self.oldNavBgColor;
    
    [UIApplication sharedApplication].statusBarStyle=self.statusBarStyle;
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //记录原来的信息
    self.isNavigationShow = self.navigationController.navigationBarHidden;
    self.oldNavBgColor=self.navigationController.navigationBar.barTintColor;
    self.statusBarStyle=[UIApplication sharedApplication].statusBarStyle;
    
    //设置现在要处的状态
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    
    [super viewDidAppear:animated];
}

@end
