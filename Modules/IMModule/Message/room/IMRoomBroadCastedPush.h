//
//  IMRoomBroadCastePush.h
//  BanLiTV
//
//  Created by ZT on 16/5/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMessage.h"

@interface IMRoomBroadCastedPush : IMMessage

-(BOOL)push:(NSArray*)info;

@end
