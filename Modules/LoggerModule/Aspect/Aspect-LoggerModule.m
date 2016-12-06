//
//  Aspect-LoggerModule.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect-LoggerModule.h"

@implementation Aspect_LoggerModule

+(void)load
{
   [[AKFileLogger sharedInstance] configureLogging];
}
@end
