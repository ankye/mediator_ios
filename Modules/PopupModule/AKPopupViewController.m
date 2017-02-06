//
//  AKPopupViewController.m
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "BaseModuleDefine.h"
#import "AKPopupViewController.h"


@interface AKPopupViewController()
{
    AKBasePopupView* _customView;
}

@end

@implementation AKPopupViewController



- (instancetype)init
{
    if (self = [super init]) {
        
        _customView = nil;
        
        
        
        
    }
    return self;
}

-(id)initWithView:(AKBasePopupView*)customView
{
    if(self = [self init]){
        _customView = customView;
        [self.view addSubview:customView];
        if([customView isFullScreen]){
            CGSize size = [self.view size];
            self.contentSizeInPopup = CGSizeMake(size.width, size.height);
            self.landscapeContentSizeInPopup = CGSizeMake(size.height, size.width);
        }else{
            self.contentSizeInPopup = [customView portraitSize];
            self.landscapeContentSizeInPopup = [customView landscapeSize];
        }
        
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.view);
        }];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add views here
    // self.view.frame.size == self.contentSizeInPopup in portrait
    // self.view.frame.size == self.landscapeContentSizeInPopup in landscape
}

-(void)dealloc
{
    
}

@end
