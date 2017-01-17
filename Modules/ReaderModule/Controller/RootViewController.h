//
//  RootViewController.h
//  比颜值
//
//  Created by 陈行 on 16-1-12.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Category.h"
#import "NSString+Category.h"
#import "NSObject+Category.h"
#import "UIImageView+WebCache.h"

#import "WebViewController.h"
#import "CustomShareView.h"
#import "RootMaskView.h"
#import "RootNavButton.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#import "SQLiteManager.h"
#import "RequestUtil.h"

#import "InitialData.h"


@interface RootViewController : UIViewController<RequestUtilDelegate>

@property(nonatomic,strong)RequestUtil * requestUtil;

@end
