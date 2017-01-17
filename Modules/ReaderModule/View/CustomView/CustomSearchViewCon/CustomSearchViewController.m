//
//  SearchViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomSearchViewController.h"
#import "CustomSearchView.h"

@interface CustomSearchViewController ()<CustomSearchViewDelegate>



@end

@implementation CustomSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    CustomSearchView * searchView=[[CustomSearchView alloc]initWithFrame:self.view.bounds];
    searchView.delegate=self;
    searchView.maxRowCount = 7;
    [self.view addSubview:searchView];
    
}

- (void)customSearchBar:(CustomSearchView *)searchView andCancleBtn:(UIButton *)cancleBtn{
    if([self.delegate respondsToSelector:@selector(searchViewControllerCancleButtonClicked:)]){
        [self.delegate searchViewControllerCancleButtonClicked:self];
    }
}

- (void)customSearchBar:(CustomSearchView *)searchView andSearchValue:(NSString *)searchValue{
    if([self.delegate respondsToSelector:@selector(searchViewControllerSearchButtonClicked:andSearchValue:)]){
        [self.delegate searchViewControllerSearchButtonClicked:self andSearchValue:searchValue];
    }
}


#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}

@end
