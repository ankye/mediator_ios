//
//  AKTabbarControllerFactory.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"

@interface AKTabbarControllerFactory : NSObject

+ (instancetype)defaultFactory;

-(UITabBarController*)createWithPlist:(NSString*)plist;

@end
