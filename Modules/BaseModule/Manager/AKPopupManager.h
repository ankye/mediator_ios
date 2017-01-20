//
//  PopupManager.h
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKPopupViewProtocol.h"
#import "BaseModuleDefine.h"

#define AK_POPUP_MANAGER [AKPopupManager sharedInstance]


@interface AKPopupManager : NSObject <UIGestureRecognizerDelegate,STPopupControllerTransitioning>


SINGLETON_INTR(AKPopupManager)



+(NSMutableDictionary*)buildPopupAttributes:(BOOL)showBG showNav:(BOOL)showNav style:(STPopupStyle)style onClick:(AKPopupOnClick)onClick onClose:(AKPopupOnClose)onClose;

/**
 弹出窗，注入视图View

 @param customView 定制的显示视图
 @param attributes 属性字典，参考构建者 [AKPopupManager buildPopupAttributes]
 */
-(void)showView:(AKBasePopupView*)customView withAttributes:(NSMutableDictionary*)attributes;

/**
 弹出窗，注入Controller

 @param controller 定制的Controller
 @param attributes 属性字典，参考构建者 [AKPopupManager buildPopupAttributes]
 */
-(void)showController:(UIViewController*)controller withAttributes:(NSMutableDictionary*)attributes;

-(void)hidden;

-(void)push:(UIViewController*)controller;

+(void)showTips:(NSString*)text;
+(void)showErrorTips:(NSString *)text;

+(void)showProgressHUD;
+(void)hideProgressHUD;

+(void)showProgressHUDAtView:(UIView*)view;
+(void)hideProgressHUDAtView:(UIView*)view;


@end
