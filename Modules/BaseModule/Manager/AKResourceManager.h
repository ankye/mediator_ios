//
//  AKResourceManager.h
//  Project
//
//  Created by ankye on 2016/12/19.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"


@interface AKResourceManager : NSObject


/**
 移除未使用的资源
 */
+(void)removeUnusedResource;


/**
 加载图片资源
 注:如果使用的是.xcassets，则直接调用系统的[UIImage imageNamed]
 @param name 图片名
 @return UIImage
 */
+ (UIImage*)imageNamed:(NSString*)name;


@end
