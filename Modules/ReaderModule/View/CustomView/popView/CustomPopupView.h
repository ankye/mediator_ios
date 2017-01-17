//
//  PopupView.h
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopupItem.h"
#import "CustomPopupWindow.h"

@class CustomPopupView;

@protocol CustomPopupViewDelegate <NSObject>

- (void)customPopupViewDetermineTouch:(CustomPopupView *)popupView;

@end

@interface CustomPopupView : UIView

@property (nonatomic, strong) CustomPopupWindow *mainWindow;
@property (nonatomic, strong) CustomPopupItem *popup;

@property(nonatomic,weak)id<CustomPopupViewDelegate>delegate;

- (instancetype)initWithPopup:(CustomPopupItem*)popup;

+ (instancetype)customPopupViewWithMsg:(NSString *)msg;

+ (instancetype)customPopupViewWithTitle:(NSString *)title msg:(NSString *)msg btnContent:(NSString *)btnContent;

@end
