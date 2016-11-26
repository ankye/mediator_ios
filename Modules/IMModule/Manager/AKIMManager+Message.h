//
//  IMManager+Message
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKIMManager.h"

#define REQ_IM_SAY              @"im.say"
#define NOT_IM_SAID             @"im.said"
#define REQ_IM_GET              @"im.get"
#define REQ_IM_GETMAXINDICES    @"im.getMaxIndices"
#define REQ_IM_GETUNREADLIST    @"im.get_unread_list"
#define REQ_IM_CLEARUNREADNUM   @"im.clear_unread_num"
#define REQ_IM_REVOKE           @"im.revoke"
#define NOT_IM_REVOKED          @"im.revoked"
#define REQ_IM_REMOVE           @"im.remove"


@interface AKIMManager (Message)

//消息注册
-(void)messageRegister;


//注册消息命令和消息类
-(void)registerMessageClass:(NSString*)cmd className:(NSString*)className;

//创建消息入口
-(Class)createMessage:(NSString*)cmd;


@end
