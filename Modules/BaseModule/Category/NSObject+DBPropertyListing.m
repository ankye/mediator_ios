//
//  NSObject+PropertyListing.m
//  LTDemo
//
//  Created by PeteOu on 16/8/9.
//  Copyright © 2016年 PeteOu. All rights reserved.
//

#import "NSObject+DBPropertyListing.h"
#import <objc/runtime.h>

@implementation NSObject (DBPropertyListing)

- (NSArray *)fetchPropertyList{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}





- (NSArray *)fetchPropertyAttributes{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesAttrArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyAttr = property_getAttributes(properties[i]);
        [propertiesAttrArray addObject: [NSString stringWithUTF8String:propertyAttr]];
    }
    free(properties);
    return propertiesAttrArray;
}

-  (NSArray *)fetchDBObjectPropertyList{
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithCapacity:1];
    if ([NSStringFromClass([self class]) isEqualToString:@"DBBaseObject"]) {
        [finalArray addObjectsFromArray:[self fetchPropertyList]];
    }else{
        id superObject = [[[self superclass] alloc] init];
        [finalArray addObjectsFromArray:[superObject fetchDBObjectPropertyList]];
        [finalArray addObjectsFromArray:[self fetchPropertyList]];
    }
    
    return finalArray;
}

- (NSArray *)fetchDBObjectPropertyAttributes{
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithCapacity:1];
    if ([NSStringFromClass([self class]) isEqualToString:@"DBBaseObject"]) {
        [finalArray addObjectsFromArray:[self fetchPropertyAttributes]];
    }else{
        id superObject = [[[self superclass] alloc] init];
        [finalArray addObjectsFromArray:[superObject fetchDBObjectPropertyAttributes]];
        [finalArray addObjectsFromArray:[self fetchPropertyAttributes]];
    }
    
    return finalArray;
}

@end
