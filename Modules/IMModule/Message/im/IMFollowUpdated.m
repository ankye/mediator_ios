//
//  IMFollowUpdated.m
//  BanLiTV
//
//  Created by kai hu on 16/7/26.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMFollowUpdated.h"

@implementation IMFollowUpdated

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
   
    return YES;
}

@end
