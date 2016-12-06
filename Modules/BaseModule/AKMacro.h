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
#define     SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define     SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
