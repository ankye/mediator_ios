//
//  AKMediator+IMModule.h
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator.h"
#import "IMMessageDef.h"

@interface AKMediator (IMModule)


/**
 请求im服务器列表，保存在IMManager里面
 */
-(void)im_requestIMServerList;



/**
 从web服务器请求Token

 @param uid 用户id
 @param userToken 用户授权登录Token
 */
-(void)im_requestIMToken:(NSString*)uid withUserToken:(NSString*)userToken;


-(UIView<AKPopupViewProtocol>*)im_popupConversationView;

@end
