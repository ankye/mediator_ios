//
//  AKLoginButtonGroup.m
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKLoginButtonGroup.h"
#import "AKLoginButton.h"

@interface AKLoginButtonGroup()

@property (nonatomic,strong) NSMutableArray* loginBtns;
@property (nonatomic, strong) NSArray* btnInfos;

@end
@implementation AKLoginButtonGroup

-(id)init
{
    self = [super init];
    if(self){
        
        self.loginBtns = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)updateButtonInfos:(NSArray*)btnInfo
{
    [self.loginBtns removeAllObjects];
    
    self.btnInfos =btnInfo;
    
    
    for(NSInteger i = 0; i< [self.btnInfos count]; i++)
    {
        NSDictionary* dic = [self.btnInfos objectAtIndex:i];
        AKLoginButton* btn = [AKLoginButton buttonWithFrame:CGRectMake(0, 0, 54, 157) title:dic[@"title"] image: [UIImage imageNamed:dic[@"nornal"]] highlightedImage:nil];
        
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [self addSubview:btn];
        [self.loginBtns addObject:btn];
    }
    
}

-(void)layoutSubviews
{
    
    
    float spacing = 50.0;
    
    [self.loginBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:54 leadSpacing:spacing tailSpacing:spacing];
    [self.loginBtns mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.mas_equalTo(2);
        make.height.mas_equalTo(self.mas_height);
    }];
    
}

-(void)onBtnClick:(id)sender
{
    
    UIButton* clickButton = (UIButton*)sender;
    NSInteger tag = clickButton.tag;
    if(self.delegate){
        [self.delegate onButtonClick:tag];
    }
}


-(void)dealloc
{
    self.btnInfos = nil;
    [self.loginBtns removeAllObjects];
    self.loginBtns = nil;
}

@end
