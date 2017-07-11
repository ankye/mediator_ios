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
#import "AKPopupAttributes.h"
#import "AKPopupFadeAction.h"

@interface AKPopupManager()

@property (nonatomic,strong) STPopupController*     popupController;
@property (nonatomic,strong) NSMutableArray*        popupQueue;
@property (nonatomic,strong) AKPopupAttributes*   currentAttributes;

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

+(AKPopupAttributes*)buildPopupAttributes:(BOOL)showBG showNav:(BOOL)showNav style:(STPopupStyle)style actionType:(AKPopupActionType)actionType onClick:(AKPopupOnClick)onClick onClose:(AKPopupOnClose)onClose  onCompleted:(AKPopupOnCompleted)onCompleted
{
    AKPopupAttributes* attr =  [[AKPopupAttributes alloc] init];
    
    attr.showBG =  showBG;
    attr.showNav = showNav;
    attr.onClick = onClick;
    attr.onClose = onClose;
    attr.onCompleted = onCompleted;
    attr.style = style;
    attr.actionType = actionType;
    
    return attr;
}



//最终显示弹窗的地方
-(void)show
{
    if( [self.popupQueue count] == 0){
        return;
    }
    if(self.currentAttributes){
        if( self.currentAttributes.priority != AKPopupPriorityForceShow && self.currentAttributes.locked == NO){
            AKPopupAttributes* attributes = [self.popupQueue objectAtIndex:0];
            if(attributes.priority == AKPopupPriorityForceShow){
                [self hidden];
                NSInteger index = 0;
                AKPopupAttributes* tempAttrs = nil;
                for(NSInteger i=0; i<[self.popupQueue count]; i++){
                    tempAttrs = [self.popupQueue objectAtIndex:i];
                    if(tempAttrs.priority == AKPopupPriorityForceShow){
                        index = i;
                    }else{
                        break;
                    }
                }
                
                [self.popupQueue insertObject:self.currentAttributes atIndex:index+1];
            
            }
            return;
        }else{
            return;
        }
    }
    self.currentAttributes = [self.popupQueue objectAtIndex:0];
    self.currentAttributes.locked = NO;
    [self.popupQueue removeObjectAtIndex:0];
    AKPopupAttributes* attributes = self.currentAttributes;
    
    AKPopupViewController* controller = (AKPopupViewController*)attributes.controller;
    
    self.popupController = [[STPopupController alloc] initWithRootViewController:controller];
    self.popupController.containerView.layer.cornerRadius = 4;
    self.popupController.transitionStyle = STPopupTransitionStyleCustom;
    
 
    
    AKPopupActionType actionType = attributes.actionType;
    
    AKPopupBaseAction* action = [self createAction:actionType];
    
    action.onCompleted = ^(){
        self.popupController = nil;
        AKPopupOnCompleted onCompleted = self.currentAttributes.onCompleted; 
        if(onCompleted){
            onCompleted(nil);
        }
        self.currentAttributes = nil;
        [self show];
    };
    controller.popupAction = action;
    
    self.popupController.transitioning = controller.popupAction;
    
    self.popupController.style = attributes.style;
    
    
    
    if(attributes.showBG){
        if (NSClassFromString(@"UIBlurEffect")) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        }
    }else{
        [self.popupController.backgroundView setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)]];
    
    if(attributes.showNav) {
        
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
        case AKPopupActionTypeFade:
            return [[AKPopupFadeAction alloc] init];
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

-(void)showController:(UIViewController*)controller withAttributes:(AKPopupAttributes *)attributes
{

    attributes.controller = controller;
    
    [self.popupQueue addObject:attributes];
    
    [self.popupQueue sortUsingComparator:^NSComparisonResult(AKPopupAttributes* obj1,AKPopupAttributes* obj2){
        return obj1.priority < obj2.priority;
    }];
    
    
    [self show];
    
}



-(void)showView:(AKBasePopupView*)customView withAttributes:(AKPopupAttributes *)attributes
{
    
    AKPopupViewController* vc = [[AKPopupViewController alloc] initWithView:customView];
    AKPopupOnClose closeBlock = attributes.onClose;
    @weakify(self);
    attributes.onClose =  ^( NSMutableDictionary* extend){
        
        @strongify(self);
        [self hidden];
        closeBlock(extend);
        
    };
    customView.onClick = attributes.onClick;
    customView.onClose = attributes.onClose;
    
   
    [self showController:vc withAttributes:attributes];
    
}


-(void)hidden
{
    if(self.currentAttributes){
        self.currentAttributes.locked = YES;
    }
   
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

-(void)showConfirmAlert:(NSString*)title withDetail:(NSString*)detail withAttributes:(AKPopupAttributes*)attributes
{
    MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:title detail:detail];
    [self showView:alertView withAttributes:attributes];
    
}

-(void)showChooseAlert:(NSString*)title withDetail:(NSString*)detail withItems:(NSArray*)items withAttributes:(AKPopupAttributes*)attributes
{
    if(items == nil){
        items =
        @[MMItemMake(@"Cancel", MMItemTypeNormal, 1),
          MMItemMake(@"Confirm", MMItemTypeHighlight, 2)
          ];
    }
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:title detail:detail items:items];
     [self showView:alertView withAttributes:attributes];
}

-(void)showInputAlert:(NSString*)title withDetail:(NSString*)detail withPlaceholder:(NSString*)placeholder withHandler:(MMPopupInputHandler)handler withAttributes:(AKPopupAttributes*)attributes
{
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:title detail:detail placeholder:placeholder handler:handler];
    [self showView:alertView withAttributes:attributes];

}

-(void)showSheetAlert:(NSString*)title withItems:(NSArray*)items withAttributes:(AKPopupAttributes*)attributes
{
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title items:items];
    attributes.style = STPopupStyleBottomSheet;
    
    [self showView:sheetView withAttributes:attributes];
}


-(void)showDateAlert:(AKPopupAttributes*)attributes
{
    MMDateView *view = [[MMDateView alloc] init];
    attributes.style = STPopupStyleBottomSheet;
   
    [self showView:view withAttributes:attributes];
}

@end
