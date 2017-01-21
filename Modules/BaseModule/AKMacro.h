//
//  AKMacro.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

//单例宏定义

#define SINGLETON_INTR( _name ) + ( _name *) sharedInstance;

#define SINGLETON_IMPL( _name ) \
+ ( _name *) sharedInstance { \
__strong static _name * _sharedInstance = nil; \
static dispatch_once_t oncePredicate = 0; \
dispatch_once( &oncePredicate, ^{_sharedInstance = [[ _name alloc] init];} ); \
return _sharedInstance; \
}



#pragma mark - # SIZE
#define     SCREEN_FRAME                 [UIScreen mainScreen].bounds
#define     SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define     SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define     SCREEN_TABBAR_HEIGHT        48.0f
#define     SCREEN_NAV_HEIGHT           64.0f


#define     AKURL(urlString)    [NSURL URLWithString:urlString]
#define     AKNoNilString(str)  (str.length > 0 ? str : @"")
#define     AKNoNilNumber(obj)  (obj == nil ? @(0): obj)
#define     AKWeakSelf(type)    __weak typeof(type) weak##type = type;
#define     AKStrongSelf(type)  __strong typeof(type) strong##type = type;
#define     AKTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])
#define     AKColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define     AKRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define     AKColorString(str) [UIColor colorWithHexString:str]; 
#define     AK1PXLine            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
