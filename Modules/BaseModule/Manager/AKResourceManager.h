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


+(void)removeUnusedResource;

+ (UIImage*)imageNamed:(NSString*)name;


@end
