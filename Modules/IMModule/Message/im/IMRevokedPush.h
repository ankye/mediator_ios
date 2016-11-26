//
//  IMRevokedPush.h
//  BanLiTV
//
//  Created by hk on 16/5/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMRevokedPush : IMMessage
-(BOOL)push:(NSArray*)info;
@end
