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

+(NSMutableDictionary*)buildPopupAttributes:(BOOL)showBG showNav:(BOOL)showNav style:(STPopupStyle)style onClick:(AKPopupOnClick)onClick onClose:(AKPopupOnClose)onClose
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
    
    UIViewController* controller = attributes[AK_Popup_Controller];
    
    self.popupController = [[STPopupController alloc] initWithRootViewController:controller];
    self.popupController.containerView.layer.cornerRadius = 4;
    self.popupController.transitionStyle = STPopupTransitionStyleCustom;
    
    self.popupController.transitioning = self;
    
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



- (NSTimeInterval)popupControllerTransitionDuration:(STPopupControllerTransitioningContext *)context
{
    return context.action == STPopupControllerTransitioningActionPresent ? 0.5 : 0.35;
}

- (void)popupControllerAnimateTransition:(STPopupControllerTransitioningContext *)context completion:(void (^)())completion
{
    UIView *containerView = context.containerView;
    if (context.action == STPopupControllerTransitioningActionPresent) {
        containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - containerView.frame.origin.y);
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            context.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }
    else {
        CGAffineTransform lastTransform = containerView.transform;
        containerView.transform = CGAffineTransformIdentity;
        CGFloat originY = containerView.frame.origin.y;
        containerView.transform = lastTransform;
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - originY + containerView.frame.size.height);
        } completion:^(BOOL finished) {
            containerView.transform = CGAffineTransformIdentity;
            completion();
            self.popupController = nil;
            self.currentAttributes = nil;
            [self show];
            
        }];
    }
}

-(void)showTips:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleInfo];
    });
    
}

-(void)showErrorTips:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleError];
    });
    
}
@end
