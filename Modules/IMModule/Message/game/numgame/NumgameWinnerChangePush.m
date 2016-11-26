//
//  NumgameWinnerChangePush.m
//  BanLiTV
//
//  Created by zhout on 16/9/8.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "NumgameWinnerChangePush.h"

@implementation NumgameWinnerChangePush

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
