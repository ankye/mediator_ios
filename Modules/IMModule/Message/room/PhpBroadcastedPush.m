//
//  PhpBroadcastedPush.m
//  BanLiTV
//
//  Created by 栾有数 on 16/6/13.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "PhpBroadcastedPush.h"

@implementation PhpBroadcastedPush
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
