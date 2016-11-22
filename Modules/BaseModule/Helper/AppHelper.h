//
//  AppHelper.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"


@interface AppHelper : NSObject



//判断空字符串
+(BOOL)isNullString:(NSString *)string;

//获取根节点UIViewController
+ (UIViewController*)getRootController ;

//获取根节点UINavigationController
+ (UINavigationController*)getNaviController ;
@end
