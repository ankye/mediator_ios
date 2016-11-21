//
//  Helper.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"


@interface Helper : NSObject

+(NSArray*)getPlist:(NSString*)name;

//判断空字符串
+(BOOL)isNullString:(NSString *)string;


+ (UIViewController*)getRootController ;

+ (UINavigationController*)getNaviController ;
@end
