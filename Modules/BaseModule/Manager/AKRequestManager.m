//
//  AKRequestManager.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKRequestManager.h"

@interface AKRequestManager()

@property (nonatomic,strong) NSMutableDictionary* httpHeaderField;

@end

@implementation AKRequestManager


SINGLETON_IMPL(AKRequestManager)


//删除http request header 某个field信息
-(void)removeHttpHeaderField:(NSString*)key
{
    if(_httpHeaderField == nil){
        return;
    }
    [self.httpHeaderField setNilValueForKey:key];
    
}
//覆盖整个http request header 信息
-(void)setHttpHeaderWithDictionary:(NSMutableDictionary*)dic
{
    self.httpHeaderField = dic;
}
//更新http request 头部信息
-(void)updateHttpHeaderField:(NSString*)key withValue:(NSString*)value
{
    if(_httpHeaderField == nil){
        _httpHeaderField = [[NSMutableDictionary alloc] init];
    }
    [self.httpHeaderField setValue:value forKey:key];
    
}
//获取http request 头部信息
-(NSDictionary*)getHttpHeaderField
{
    return self.httpHeaderField;
}

@end
