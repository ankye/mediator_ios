//
//  IMRevokeMessage.h
//  BanLiTV
//
//  Created by hk on 16/5/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMRevokeMessage : IMMessage

@property(nonatomic, strong)NSString *toUid;

@property(nonatomic, strong)NSNumber *revokeIndex;

-(BOOL)request;

-(BOOL)timeout;
@end
