//
//  RootViewController.m
//  比颜值
//
//  Created by 陈行 on 16-1-12.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;

    self.navigationController.navigationBar.barTintColor= [UIColor colorWithHexString:@"#3c93d6"];
    //设置字体颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

#pragma mark - 懒加载
- (RequestUtil *)requestUtil{
    if(_requestUtil==nil){
        _requestUtil=[[RequestUtil alloc]init];
        _requestUtil.delegate=self;
        _requestUtil.view=self.view;
        _requestUtil.isShowProgressHud=YES;
    }
    return _requestUtil;
}

#pragma mark - 系统协议
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_requestUtil) {
//        _requestUtil.delegate=nil;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([NSStringFromClass([self class]) isEqualToString:@"UserLoginViewController"]) {
        
    }else if ([self.navigationController.viewControllers objectAtIndex:0]==self) {
        self.tabBarController.tabBar.hidden=NO;
    }else{
        self.tabBarController.tabBar.hidden=YES;
    }
    if (_requestUtil) {
        _requestUtil.delegate=self;
    }
}

- (void)didReceiveMemoryWarning{
    NSLog(@"%@-------->内存溢出",NSStringFromClass([self class]));
    [super didReceiveMemoryWarning];
}


//- (void)dealloc{
//    NSLog(@"%@",NSStringFromClass([self class]));
//}
//
//- (void)shifangView:(UIView *)view{
//    static NSInteger i=0;
//    if(view.subviews.count==0){
//        NSLog(@"%ld",(long)i);
//        [view removeFromSuperview];
//        i++;
//        return;
//    }
//    for (UIView * subView in view.subviews) {
//        [self shifangView:subView];
//    }
//}

@end
