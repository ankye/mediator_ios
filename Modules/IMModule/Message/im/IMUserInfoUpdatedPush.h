//
//  IMUserInfoUpdatedPush.h
//  BanLiTV
//
//  Created by Luan Alex on 16/10/25.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"
//用户 信息变更通知
@interface IMUserInfoUpdatedPush : IMMessage

- (BOOL)push:(NSArray *)info;

@end
