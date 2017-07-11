//
//  PopupModuleDefine.h
//  Project
//
//  Created by ankye on 2017/2/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#ifndef PopupModuleDefine_h
#define PopupModuleDefine_h
#import "STPopup.h"

@class AKPopupAttributes;

//完成事件设置
typedef void(^CompleteFunc)() ;


//popup点击事件回调，通过点击channel来判断需要的逻辑
typedef void(^AKPopupOnClick)(NSInteger channel,NSMutableDictionary* extend);

//onClose关闭事件回调
typedef void(^AKPopupOnClose)( NSMutableDictionary* extend);
//onCompleted弹窗完成回调
typedef void(^AKPopupOnCompleted)( NSMutableDictionary* extend);

//弹窗key定义
//#define AK_Popup_Controller     @"controller"       //controller
//#define AK_Popup_ShowBG         @"showBG"           //显示背景，BOOL类型
//#define AK_Popup_ShowNav        @"showNav"          //显示导航条
//#define AK_Popup_OnClick        @"onClick"          //点击事件 非必须
//#define AK_Popup_OnClose        @"onClose"          //关闭事件 非必须
//#define AK_Popup_OnCompleted    @"onCompleted"      //完成事件 非必须
//#define AK_Popup_Style          @"style"            //弹窗样式
//#define AK_Popup_ActionType     @"actionType"       //弹窗动画和方向
//#define AK_Popup_Priority       @"priority"         //优先级

typedef NS_ENUM(NSUInteger, AKPopupActionType) {
    AKPopupActionTypeTop,
    AKPopupActionTypeBottom,
    AKPopupActionTypeLeft,
    AKPopupActionTypeRight,
    AKPopupActionTypeSpringTop,
    AKPopupActionTypeSpringBottom,
    AKPopupActionTypeSpringLeft,
    AKPopupActionTypeSpringRight,
    AKPopupActionTypeFade,
};

typedef NS_ENUM(NSUInteger, AKPopupPriority) {
   AKPopupPriorityLow = 1,
   AKPopupPriorityMediun = 2,
   AKPopupPriorityHigh = 3,
   AKPopupPriorityForceShow = 4,
};

#endif /* PopupModuleDefine_h */
