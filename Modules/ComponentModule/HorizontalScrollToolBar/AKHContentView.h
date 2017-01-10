//
//  ChildViewController.h
//  ZKHorizontalScrollToolBar
//
//  Created by 郑凯 on 2016/11/30.
//  Copyright © 2016年 tzktzk1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKDataHandlerProtocol.h"
#import "AKHScrollToolBarProtocol.h"

@interface AKHContentView : UIView <AKHScrollToolBarProtocol>

@property (nonatomic,strong) id<AKDataHandlerProtocol> handler ;
@property (nonatomic,strong) UIView* contentView;

-(NSString*)getTitle;
@end
