//
//  AKBaseModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseModel.h"

@implementation AKBaseModel




-(void)fillData:(id<AKDataObjectProtocol>)object
{
    
}

-(void)resultSetToModel:(FMResultSet *)set
{
    
}

-(NSArray*)modelDBProperties
{
    return [AKBaseModel propertyArrayWithClass:[self class]];
}
-(NSArray*)modelToDBRecord
{
    return nil;
}

+ (NSArray *)propertyArrayWithClass:(Class)clazz{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    unsigned int count;
    
    objc_property_t * pros=class_copyPropertyList(clazz, &count);
    
    for(int i=0;i<count;i++){
        objc_property_t property= pros[i];
        const char * nameChar=property_getName(property);
        NSString * name=[NSString stringWithFormat:@"%s",nameChar];
        [array addObject:name];
    }
    free(pros);
    return array;
}


@end
