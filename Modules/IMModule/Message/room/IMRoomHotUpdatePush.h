//
//  IMRoomHotUpdatePush.h
//  BanLiTV
//
//  Created by Luan Alex on 16/7/29.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMRoomHotUpdatePush : IMMessage

-(BOOL)push:(NSArray*)info;

@end
