//
//  NumgameJackpotChangedPush.m
//  BanLiTV
//
//  Created by zhout on 16/8/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "NumgameJackpotChangedPush.h"

@implementation NumgameJackpotChangedPush

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
