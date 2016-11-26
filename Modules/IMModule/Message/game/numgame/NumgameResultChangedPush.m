//
//  NumgameResultChangedPush.m
//  BanLiTV
//
//  Created by Luan Alex on 16/8/23.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "NumgameResultChangedPush.h"

@implementation NumgameResultChangedPush


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
