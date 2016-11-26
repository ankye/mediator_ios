//
//  IMRoomHotUpdatePush.m
//  BanLiTV
//
//  Created by Luan Alex on 16/7/29.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMRoomHotUpdatePush.h"


@implementation IMRoomHotUpdatePush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}



-(BOOL)push:(NSArray *)info
{
    /**
     *  房间热度推送
     */
    if (info.count<=1) {
        return YES;
    }
   
    return YES;

}

@end
