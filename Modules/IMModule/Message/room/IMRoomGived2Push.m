//
//  IMRoomGived2Push.m
//  BanLiTV
//
//  Created by ZT on 16/6/6.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomGived2Push.h"

@implementation IMRoomGived2Push

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
