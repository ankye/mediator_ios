//
//  AKRequestManager.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"

@interface AKRequestManager : NSObject

SINGLETON_INTR(AKRequestManager)

//删除http request header 某个field信息
-(void)removeHttpHeaderField:(NSString*)key;

//覆盖整个http request header 信息
-(void)setHttpHeaderWithDictionary:(NSMutableDictionary*)dic;

//更新http request 头部信息
-(void)updateHttpHeaderField:(NSString*)key withValue:(NSString*)value;
//获取http request 头部信息
-(NSDictionary*)getHttpHeaderField;

@end
