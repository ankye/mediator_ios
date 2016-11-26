//
//  IMHeartBeatMessage.h
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMHeartBeatNotify :IMMessage

-(BOOL)notify;

-(BOOL)timeout;



@end
