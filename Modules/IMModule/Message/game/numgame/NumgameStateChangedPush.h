//
//  NumgameStateChangedPush.h
//  BanLiTV
//
//  Created by Luan Alex on 16/8/23.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

//游戏状态变更时广播。

@interface NumgameStateChangedPush : IMMessage

-(BOOL)push:(NSArray*)info;

@end
