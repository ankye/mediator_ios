//
//  IMRemoveMessage.h
//  BanLiTV
//
//  Created by hk on 16/6/23.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"

@interface IMRemoveMessage : IMMessage

@property(nonatomic, strong)NSString *uid;
@property (assign,nonatomic)NSNumber *startIndex;
@property (assign,nonatomic)NSNumber *endIndex;

-(BOOL)request;

-(BOOL)response:(NSArray*)info;

-(BOOL)timeout;

@end
