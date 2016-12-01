//
//  ServiceIM.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceIM.h"
#import "AKIMManager.h"
#import "AKIMManager+Message.h"
#import "AKIMManager+IM.h"
#import "AKIMManager+Room.h"
#import "TLConversationView.h"

@implementation ServiceIM

/**
 请求im服务器列表，保存在IMManager里面
 */
-(NSNumber*)requestIMServerList:(NSDictionary*)params
{
    [[AKIMManager sharedInstance] requestIMServerList];
    return @(YES);
}

/**
 从WEB服务器请求IM访问token
 
 @param params 请求参数字典
 @return YES OR NO
 */
-(NSNumber*)requestIMToken:(NSDictionary*)params
{
    [[AKIMManager sharedInstance] requestIMToken:params[@"uid"] withUserToken:params[@"userToken"]];
    return @(YES);
}

/**
 聊天列表
 
 @param params 参数列表
 @return 返回聊天列表视图
 */
-(UIView<AKPopupViewProtocol>*)popConversationView:(NSDictionary*)params
{
    UIView<AKPopupViewProtocol>* view = [[TLConversationView alloc] init];
    
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:YES style:STPopupStyleBottomSheet onClick:^(NSInteger channel, NSMutableDictionary *attributes) {
        NSLog(@"Click");
    } onClose:^(NSMutableDictionary *attributes) {
        NSLog(@"close");
    }];
    [[AKPopupManager sharedInstance] showView:view withAttributes:attributes];
    
    return view;
}

@end
