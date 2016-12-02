//
//  NSObject+CategoryWithProperty.m
//  Project
//
//  Created by ankye on 2016/12/1.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "NSObject+CategoryWithProperty.h"


@implementation NSObject (CategoryWithProperty)

- (NSObject *)property {
    return objc_getAssociatedObject(self, @selector(property));
}

- (void)setProperty:(NSObject *)value {
    objc_setAssociatedObject(self, @selector(property), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
