//
//  MBProgressHUD+Custom.m
//  HaoYi
//
//  Created by 浩光 谢 on 16/8/19.
//  Copyright © 2016年 浩光 谢. All rights reserved.
//

#import "MBProgressHUD+Custom.h"
#import "UIView+Animation.h"

@implementation MBProgressHUD (Custom)
+(instancetype)showCustomHUDAddedTo:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView; //MBProgressHUDModeAnnularDeterminate;
    hud.color = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:0.5];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUDLoading"]];
    [hud.customView startRotateAnimating];
    return hud;
}

+(void)hideCustomHUDForView:(UIView *)view
{
    if ([[MBProgressHUD HUDForView:view] customView]) {
        [[[MBProgressHUD HUDForView:view] customView] stopLayerAnimating];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
