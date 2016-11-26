//
//  IMLiveMessage.h
//  BanLiTV
//
//  Created by zhout on 16/8/10.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMLivePingMessage : IMMessage

-(BOOL)notify;

-(BOOL)timeout;

@end
