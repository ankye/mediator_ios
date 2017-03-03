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
#import "MMAlertView.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPinView.h"
#import "MMDateView.h"

#define AK_POPUP_MANAGER [AKPopupManager sharedInstance]




@interface AKPopupManager : NSObject <UIGestureRecognizerDelegate>


SINGLETON_INTR(AKPopupManager)


//STPopupStyleBottomSheet 类型只支持 AKPopupActionTypeBottom
+(NSMutableDictionary*)buildPopupAttributes:(BOOL)showBG showNav:(BOOL)showNav style:(STPopupStyle)style actionType:(AKPopupActionType)actionType onClick:(AKPopupOnClick)onClick onClose:(AKPopupOnClose)onClose onCompleted:(AKPopupOnCompleted)onCompleted;

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

-(void)showConfirmAlert:(NSString*)title withDetail:(NSString*)detail withAttributes:(NSMutableDictionary*)attributes;

-(void)showChooseAlert:(NSString*)title withDetail:(NSString*)detail withItems:(NSArray*)items withAttributes:(NSMutableDictionary*)attributes;

-(void)showInputAlert:(NSString*)title withDetail:(NSString*)detail withPlaceholder:(NSString*)placeholder withHandler:(MMPopupInputHandler)handler withAttributes:(NSMutableDictionary*)attributes;

-(void)showSheetAlert:(NSString*)title withItems:(NSArray*)items withAttributes:(NSMutableDictionary*)attributes;

-(void)showDateAlert:(NSMutableDictionary*)attributes;

@end
