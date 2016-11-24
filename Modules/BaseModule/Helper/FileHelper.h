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


/**
 获取FMDB的数据库路径

 @param dbname 数据库名字
 @return 路径
 */
+(NSString*)getFMDBPath:(NSString*)dbname;


/**
 缓存圆形头像图片

 @return 管理类
 */
+ (YYWebImageManager *)avatarImageManager;



/**
 取得系统位置

 @return 系统路径
 */
+ (NSString *)SystemPath;


/**
 取得登陆用户位置

 @param idex index
 @return 路径
 */
+ (NSString *)getUserInfoPath:(NSString *)idex;


@end
