//
//  FileHelper.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

//通过plist名称获得数组
+(NSArray*)getArrayFromPlist:(NSString*)name
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"plist"]];
    
}


@end
