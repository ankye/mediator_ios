//
//  YMenuViewController.h
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/13.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "RootViewController.h"

@interface YMenuViewController : RootViewController

@property (copy, nonatomic) void(^menuTapAction)(NSInteger);
- (void)showMenuView;
@end
