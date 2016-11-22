//
//  UserModel.m
//  XYTV
//
//  Created by huk on 16/1/4.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "UserModel.h"
#import <YYKit/YYKit.h>



@implementation UserModel

-(void)setKey:(NSString*)key
{
    NSInteger num = [key integerValue];
    self.uid = @(num);
}

-(NSString*)getKey
{
   return [self.uid stringValue];
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
