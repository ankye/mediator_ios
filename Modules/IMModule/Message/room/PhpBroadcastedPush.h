//
//  PhpBroadcastedPush.h
//  BanLiTV
//
//  Created by 栾有数 on 16/6/13.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface PhpBroadcastedPush : IMMessage

-(BOOL)push:(NSArray*)info;

@end
