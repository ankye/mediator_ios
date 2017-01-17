//
//  PopupView.m
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import "CustomPopupView.h"

@interface CustomPopupView()<CustomPopupWindowDelegate>

@end

@implementation CustomPopupView

+ (instancetype)customPopupViewWithMsg:(NSString *)msg{
    return [[self alloc]initWithPopup:[[CustomPopupItem alloc] initWithTitle:@"提示信息" msg:msg btnContent:@"确定"]];
}

+ (instancetype)customPopupViewWithTitle:(NSString *)title msg:(NSString *)msg btnContent:(NSString *)btnContent{
    return [[self alloc]initWithPopup:[[CustomPopupItem alloc] initWithTitle:title msg:msg btnContent:btnContent]];
}

- (instancetype)initWithPopup:(CustomPopupItem*)popup
{
    self = [super init];
    if (self) {
        // 设置属性
        self.popup = popup;
        
        // 设置背景颜色
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        // 添加单击手势
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopupView:)];
//        self.userInteractionEnabled = NO;
//        [self addGestureRecognizer:gesture];
        
        // 增加主窗口
        [self addWindowView];
        self.mainWindow.progress=1;
    }
    return self;
}

-(void)addWindowView {
    // 获取屏幕信息
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat screenWidth = size.width;
    CGFloat screenHeight = size.height;
    CGFloat mainHeight = size.width * 0.7 * 0.71;
    
    self.mainWindow = [[CustomPopupWindow alloc] initWithPopup:self.popup];
    self.mainWindow.delegate=self;
    self.mainWindow.frame = CGRectMake(screenWidth * 0.15, screenHeight * 0.3, screenWidth * 0.7, mainHeight);
    self.mainWindow.layer.cornerRadius = 5;
    self.mainWindow.layer.masksToBounds = YES;
    self.mainWindow.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainWindow];
}

- (void)hidePopupView:(UITapGestureRecognizer*)gesture {
    [self removeFromSuperview];
}

- (void)determineTouch{
    [self.delegate customPopupViewDetermineTouch:self];
}

- (void)dealloc
{
//    NSLog(@"%@被销毁",[self class]);
}
@end
