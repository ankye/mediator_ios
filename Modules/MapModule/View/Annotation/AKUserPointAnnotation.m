//
//  AKUserPointAnnotation.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserPointAnnotation.h"

@implementation AKUserPointAnnotation

-(id)initWithUser:(UserModel*)user
{
    if(self = [super init]){
    
        self.user = user;
    }
    return self;
}

-(void)dealloc
{
    self.user = nil;
}

@end
