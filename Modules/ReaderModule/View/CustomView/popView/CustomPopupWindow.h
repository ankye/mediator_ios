//
//  MainWindow.h
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopupItem.h"

@protocol CustomPopupWindowDelegate <NSObject>

- (void)determineTouch;

@end

@interface CustomPopupWindow : UIView

@property(nonatomic,weak)id<CustomPopupWindowDelegate>delegate;
// 属性
@property (nonatomic, strong) CustomPopupItem *popup;
// 主题颜色
@property (nonatomic, strong)UIColor *themeColor;
// 进度
@property (nonatomic, assign)CGFloat progress;

@property(nonatomic,weak)UIButton * btn;

- (instancetype)initWithPopup:(CustomPopupItem*)popup;
@end
