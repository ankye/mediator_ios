//
//  NSObject+Category.m
//  powerlife
//
//  Created by 陈行 on 16/7/8.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>

@implementation NSObject (Category)

+ (NSArray *)propertyNameArray{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList([self class], &count);
    
    for(int i=0;i<count;i++){
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        [array addObject:name];
    }
    free(pros);
    return array;
}

- (NSArray *)propertyNameArray{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList([self class], &count);
    
    for(int i=0;i<count;i++){
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        [array addObject:name];
    }
    free(pros);
    return array;
}


- (NSString *)otherDescription{
    NSMutableString * str=[NSMutableString string];
    
    [str appendFormat:@"%@ [",NSStringFromClass([self class])];
    Class clazz=[self class];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    for(int i=0;i<count;i++){
        if(i!=0){
            [str appendString:@", "];
        }
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        id value = [self valueForKey:name];
        [str appendFormat:@"%@=%@",name,value];
    }
    [str appendString:@"]"];
    return str;
}


@end
