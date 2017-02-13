//
//  PopupManager.m
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKPopupManager.h"
#import "AKPopupViewController.h"
#import <AFMInfoBanner/AFMInfoBanner.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MBProgressHUD+Custom.h"
#import <POP/POP.h>
#import "AKPopupFromSideAction.h"
#import "AKPopupFromSideSpringAction.h"
#import "AKPopupViewController.h"


@interface AKPopupManager()

@property (nonatomic,strong) STPopupController*     popupController;
@property (nonatomic,strong) NSMutableArray*        popupQueue;
@property (nonatomic,copy) NSMutableDictionary*   currentAttributes;

@end

@implementation AKPopupManager 

SINGLETON_IMPL(AKPopupManager)

-(id)init
{
    self = [super init];
    if(self){
        self.popupQueue = [[NSMutableArray alloc] init];
        self.currentAttributes = nil;
        self.popupController = nil;
    }
    return self;
}

+(NSMutableDictionary*)buildPopupAttributes:(BOOL)showBG showNav:(BOOL)showNav style:(STPopupStyle)style actionType:(AKPopupActionType)actionType onClick:(AKPopupOnClick)onClick onClose:(AKPopupOnClose)onClose
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[AK_Popup_ShowBG] =  @(showBG);
    dic[AK_Popup_ShowNav] = @(showNav);
    dic[AK_Popup_OnClick] = onClick;
    dic[AK_Popup_OnClose] = onClose;
   
    if(style){
        dic[AK_Popup_Style] = @(style);
    }else{
        dic[AK_Popup_Style] = @(STPopupStyleFormSheet);
    }
    //目前只支持 AKPopupActionTypeBottom
    if(STPopupStyleBottomSheet == style){
        actionType = AKPopupActionTypeBottom;
    }
     dic[AK_Popup_ActionType] = @(actionType);
    
    return dic;
}



//最终显示弹窗的地方
-(void)show
{
    if(self.currentAttributes || [self.popupQueue count] == 0){
        return;
    }
    
    self.currentAttributes = [self.popupQueue objectAtIndex:0];
    [self.popupQueue removeObjectAtIndex:0];
    NSMutableDictionary* attributes = self.currentAttributes;
    
    AKPopupViewController* controller = attributes[AK_Popup_Controller];
    
    self.popupController = [[STPopupController alloc] initWithRootViewController:controller];
    self.popupController.containerView.layer.cornerRadius = 4;
    self.popupController.transitionStyle = STPopupTransitionStyleCustom;
    
 
    
    AKPopupActionType actionType = [attributes[AK_Popup_ActionType] integerValue];
    
    AKPopupBaseAction* action = [self createAction:actionType];
    
    action.onCompleted = ^(){
        self.popupController = nil;
        self.currentAttributes = nil;
        [self show];
    };
    controller.popupAction = action;
    
    self.popupController.transitioning = controller.popupAction;
    
    self.popupController.style = [attributes[AK_Popup_Style] integerValue];
    
    
    
    if([attributes[AK_Popup_ShowBG] boolValue]){
        if (NSClassFromString(@"UIBlurEffect")) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        }
    }else{
        [self.popupController.backgroundView setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)]];
    
    if([attributes[AK_Popup_ShowNav] boolValue]) {
        
        [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.86 alpha:1.0];
        [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
        [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
        [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18], NSForegroundColorAttributeName: [UIColor whiteColor] };
        
        [[UIBarButtonItem appearanceWhenContainedIn:[STPopupNavigationBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:17] } forState:UIControlStateNormal];
        
    }else{
        self.popupController.navigationBarHidden = YES;
    }
    
    
    
    [self.popupController presentInViewController:[AppHelper getRootController] completion:^{
        DDLogInfo(@"Load Popup View Completed !");
        
    }];

}
-(AKPopupBaseAction*)createAction:(AKPopupActionType)type
{
    switch (type) {
        case AKPopupActionTypeTop:
            return [[AKPopupFromSideAction alloc] initWithDirection:AKPopupActionDirectionTop];
            break;
        case AKPopupActionTypeBottom:
            return [[AKPopupFromSideAction alloc] initWithDirection:AKPopupActionDirectionBottom];

            break;
        case AKPopupActionTypeLeft:
            return [[AKPopupFromSideAction alloc] initWithDirection:AKPopupActionDirectionLeft];

            break;
        case AKPopupActionTypeRight:
            return [[AKPopupFromSideAction alloc] initWithDirection:AKPopupActionDirectionRight];

            break;
        case AKPopupActionTypeSpringTop:
            return [[AKPopupFromSideSpringAction alloc] initWithDirection:AKPopupActionDirectionTop];

            break;
        case AKPopupActionTypeSpringBottom:
            return [[AKPopupFromSideSpringAction alloc] initWithDirection:AKPopupActionDirectionBottom];

            break;
        case AKPopupActionTypeSpringLeft:
            return [[AKPopupFromSideSpringAction alloc] initWithDirection:AKPopupActionDirectionLeft];

            break;
        case AKPopupActionTypeSpringRight:
            return [[AKPopupFromSideSpringAction alloc] initWithDirection:AKPopupActionDirectionRight];
            break;
            
        default:
            return [[AKPopupFromSideAction alloc] initWithDirection:AKPopupActionDirectionTop];

            break;
    }
}

-(void)push:(UIViewController*)controller
{
    [self.popupController pushViewController:controller animated:YES];
    
}

-(void)showController:(UIViewController*)controller withAttributes:(NSMutableDictionary *)attributes
{
    attributes[AK_Popup_Controller] = controller;
    [self.popupQueue addObject:attributes];
    
    [self show];
    
}

-(void)showView:(AKBasePopupView*)customView withAttributes:(NSMutableDictionary *)attributes
{
    
    AKPopupViewController* vc = [[AKPopupViewController alloc] initWithView:customView];
    AKPopupOnClose closeBlock = [attributes objectForKey:AK_Popup_OnClose];
    @weakify(self);
    attributes[AK_Popup_OnClose] = ^( NSDictionary* attributes){
        
        @strongify(self);
        [self hidden];
        closeBlock(attributes);
        
    };
    customView.onClick = [attributes objectForKey:AK_Popup_OnClick];
    customView.onClose = [attributes objectForKey:AK_Popup_OnClose];
    
   
    [self showController:vc withAttributes:attributes];
    
}


-(void)hidden
{
    [self.popupController popViewControllerAnimated:YES]; // Popup will be dismissed if there is only one view controller in the popup view controller stack
    [self.popupController dismiss];
    self.popupController = nil;
}



+(void)showTips:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleInfo];
    });
    
}

+(void)showErrorTips:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleError];
    });
    
}

+(void)showProgressHUD
{
     dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD show];
     });
}

+(void)hideProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+(void)showProgressHUDAtView:(UIView*)view
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showCustomHUDAddedTo:view];
    });
}
+(void)hideProgressHUDAtView:(UIView*)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideCustomHUDForView:view];
    });
}

-(void)showConfirmAlert:(NSString*)title withDetail:(NSString*)detail withAttributes:(NSMutableDictionary*)attributes
{
    MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:title detail:detail];
    [self showView:alertView withAttributes:attributes];
    
}

-(void)showChooseAlert:(NSString*)title withDetail:(NSString*)detail withItems:(NSArray*)items withAttributes:(NSMutableDictionary*)attributes
{
    if(items == nil){
        items =
        @[MMItemMake(@"取消", MMItemTypeNormal, 1),
          MMItemMake(@"确认", MMItemTypeHighlight, 2)
          ];
    }
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detail items:items];
     [self showView:alertView withAttributes:attributes];
}

-(void)showInputAlert:(NSString*)title withDetail:(NSString*)detail withPlaceholder:(NSString*)placeholder withHandler:(MMPopupInputHandler)handler withAttributes:(NSMutableDictionary*)attributes
{
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:title detail:detail placeholder:placeholder handler:handler];
    [self showView:alertView withAttributes:attributes];

}

-(void)showSheetAlert:(NSString*)title withItems:(NSArray*)items withAttributes:(NSMutableDictionary*)attributes
{
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title items:items];
    attributes[AK_Popup_Style] = @(STPopupStyleBottomSheet);
    [self showView:sheetView withAttributes:attributes];
}


-(void)showDateAlert:(NSMutableDictionary*)attributes
{
    MMDateView *view = [[MMDateView alloc] init];
    attributes[AK_Popup_Style] = @(STPopupStyleBottomSheet);
    
    [self showView:view withAttributes:attributes];
}

@end
