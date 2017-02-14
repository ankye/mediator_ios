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

-(NSArray*)modelToDBRecord
{
    return [AKBaseModel propertyArrayWithClass:[self class]];
}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self modelEncodeWithCoder:aCoder];
//}
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    return [self modelInitWithCoder:aDecoder];
//}
//- (id)copyWithZone:(NSZone *)zone {
//    return [self modelCopy];
//}
//- (NSUInteger)hash {
//    return [self modelHash];
//}
//- (BOOL)isEqual:(id)object {
//    return [self modelIsEqual:object];
//}

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
