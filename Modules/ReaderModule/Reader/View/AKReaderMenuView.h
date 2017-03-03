//
//  AKReaderMenuView.h
//  Project
//
//  Created by ankye on 2017/2/24.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKView.h"

@interface AKReaderMenuView : AKView
//顶部视图
@property (nonatomic,strong) AKView* topbarView;
//底部视图
@property (nonatomic,strong) AKView* bottomBarView;


@property (copy, nonatomic) void(^menuTapAction)(NSInteger);

- (void) showMenuView;
- (void) hideMenuView;

@end
