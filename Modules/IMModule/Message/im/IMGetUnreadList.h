//
//  IMGetUnreadList.h
//  BanLiTV
//
//  Created by hk on 16/5/20.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMGetUnreadList : IMMessage

-(BOOL)request;
-(BOOL)response:(NSArray*)info;
-(BOOL)timeout;
@end
