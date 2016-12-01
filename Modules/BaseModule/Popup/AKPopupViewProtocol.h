//
//  AKPopupViewProtocol.h
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef AKPopupViewProtocol_h
#define AKPopupViewProtocol_h
#import "BaseModuleDefine.h"

//popup点击事件回调，通过点击channel来判断需要的逻辑
typedef void(^AKPopupOnClick)(NSInteger channel,NSMutableDictionary* attributes);

//onClose关闭事件回调
typedef void(^AKPopupOnClose)( NSMutableDictionary* attributes);

//弹窗key定义
#define AK_Popup_Controller     @"controller"       //controller
#define AK_Popup_ShowBG         @"showBG"           //显示背景，BOOL类型
#define AK_Popup_ShowNav        @"showNav"          //显示导航条
#define AK_Popup_OnClick        @"onClick"          //点击事件 非必须
#define AK_Popup_OnClose        @"onClose"          //关闭事件 非必须
#define AK_Popup_Style          @"style"            //弹窗样式


/**
 弹窗视图协议
 */
@protocol AKPopupViewProtocol <NSObject>

//横屏大小
-(CGSize)portraitSize;
//竖屏大小
-(CGSize)landscapeSize;


/**
 加载数据

 @param data 数据
 */
-(void)loadData:(NSObject*)data;

@end







#endif /* AKPopupViewProtocol_h */
