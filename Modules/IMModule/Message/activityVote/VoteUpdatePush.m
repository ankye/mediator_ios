//
//  VoteUpdatePush.m
//  BanLiTV
//
//  Created by 栾有数 on 16/6/8.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "VoteUpdatePush.h"

@implementation VoteUpdatePush
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
