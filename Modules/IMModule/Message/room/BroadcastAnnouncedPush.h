//
//  BroadcastAnnounced.h
//  BanLiTV
//
//  Created by Luan Alex on 16/7/12.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"
/**
 *  飞屏协议,主动通知
 */
@interface BroadcastAnnouncedPush : IMMessage

-(BOOL)push:(NSArray*)info;

@end
