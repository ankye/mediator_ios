//
//  NSObject+CategoryWithProperty.h
//  Project
//
//  Created by ankye on 2016/12/1.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (CategoryWithProperty)

/**
 *  要在Category中扩展的属性
 */
@property (nonatomic, strong) NSObject *property;

@end

