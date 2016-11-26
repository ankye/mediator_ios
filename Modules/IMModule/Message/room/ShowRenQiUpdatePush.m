//
//  ShowRenQiUpdatePush.m
//  BanLiTV
//
//  Created by Luan Alex on 16/7/7.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "ShowRenQiUpdatePush.h"

@implementation ShowRenQiUpdatePush

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
