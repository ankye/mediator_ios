//
//  IMClearUnreadNumMessage.h
//  BanLiTV
//
//  Created by hk on 16/5/24.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMClearUnreadNumMessage : IMMessage

@property(nonatomic, strong)NSString *fromUid;

@property(nonatomic, strong)NSNumber *flag;

-(BOOL)request;


-(BOOL)timeout;
@end
