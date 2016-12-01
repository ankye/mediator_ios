//
//  AKMediator+IMModule.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator+IMModule.h"
#import "AKPopupManager.h"


NSString * const kAKMIMModuleService = @"IM";
NSString * const kAKMIMModuleRequestIMServerList = @"requestIMServerList";
NSString * const kAKMIMModuleRequestIMToken = @"requestIMToken";
NSString * const kAKMIMModuleRequestIMConversationView = @"popConversationView";


@implementation AKMediator (IMModule)

/**
 请求im服务器列表，保存在IMManager里面
 */
-(void)im_requestIMServerList
{
    [self performService:kAKMIMModuleService action:kAKMIMModuleRequestIMServerList params:nil shouldCacheService:NO];
    
}

/**
 从web服务器请求Token
 
 @param userToken 用户授权登录Token
 */
-(void)im_requestIMToken:(NSNumber*)uid withUserToken:(NSString*)userToken
{
    [self performService:kAKMIMModuleService action:kAKMIMModuleRequestIMToken params:@{@"uid":uid,@"userToken":userToken} shouldCacheService:NO];
    
}

-(UIView<AKPopupViewProtocol>*)im_popupConversationView
{
    UIView<AKPopupViewProtocol>* view = [self performService:kAKMIMModuleService action:kAKMIMModuleRequestIMConversationView params:nil shouldCacheService:NO];
   
    return view;
}
@end
