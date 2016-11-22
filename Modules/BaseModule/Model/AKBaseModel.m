//
//  AKBaseModule.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseModel.h"

@implementation AKBaseModel


-(void)setKey:(NSString*)key
{
    
}

-(NSString*)getKey
{
    return nil;
}

-(void)fillData:(id<AKDataCenterObjectProtocol>)object
{
    
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}
- (NSUInteger)hash {
    return [self modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}
@end