//
//  FileHelper.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

//通过plist名称获得数组
+(NSArray*)getArrayFromPlist:(NSString*)name;

+ (YYWebImageManager *)avatarImageManager;

@end
