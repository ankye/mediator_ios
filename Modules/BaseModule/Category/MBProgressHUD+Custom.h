//
//  MBProgressHUD+Custom.h
//  HaoYi
//
//  Created by 浩光 谢 on 16/8/19.
//  Copyright © 2016年 浩光 谢. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Custom)
+(instancetype)showCustomHUDAddedTo:(UIView *)view;

+(void)hideCustomHUDForView:(UIView *)view;
@end
