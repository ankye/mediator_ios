//
//  NSFileManager+ExpressionGroup.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFileManager+Paths.h"

@interface NSFileManager (ExpressionGroup)

+ (NSString *)pathExpressionForGroupID:(NSString *)groupID;

@end
