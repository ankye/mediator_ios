//
//  AKPopupAttributes.h
//  Project
//
//  Created by ankye sheng on 2017/7/10.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PopupModuleDefine.h"

//#define AK_Popup_Controller     @"controller"       //controller
//#define AK_Popup_ShowBG         @"showBG"           //显示背景，BOOL类型
//#define AK_Popup_ShowNav        @"showNav"          //显示导航条
//#define AK_Popup_OnClick        @"onClick"          //点击事件 非必须
//#define AK_Popup_OnClose        @"onClose"          //关闭事件 非必须
//#define AK_Popup_OnCompleted    @"onCompleted"      //完成事件 非必须
//#define AK_Popup_Style          @"style"            //弹窗样式
//#define AK_Popup_ActionType     @"actionType"       //弹窗动画和方向
//#define AK_Popup_Priority       @"priority"         //优先级

@interface AKPopupAttributes : NSObject
@property (nonatomic,strong) UIViewController* controller;
@property (nonatomic,assign) BOOL showBG;
@property (nonatomic,assign) BOOL showNav;
@property (nonatomic,strong) AKPopupOnClick onClick;
@property (nonatomic,strong) AKPopupOnCompleted onCompleted;
@property (nonatomic,strong) AKPopupOnClose onClose;
@property (nonatomic,assign) AKPopupActionType actionType;
@property (nonatomic,assign) STPopupStyle style;
@property (nonatomic,assign) AKPopupPriority priority;
@property (nonatomic,assign) BOOL locked;
@end
