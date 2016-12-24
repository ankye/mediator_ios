//
//  AKNewsChannel.m
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsChannel.h"

@implementation AKNewsChannel

-(id)initWithChannel:(NSString*)cid withName:(NSString*)name withFixed:(BOOL)fixed
{
    self = [self init];
    if(self){
        self.cid = cid;
        self.name = name;
        self.fixed = fixed;
    }
    return self;
}
@end
