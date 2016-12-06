//
//  UIFont+TLChat.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIFont (TLChat)

#pragma mark - Common
+ (UIFont *)fontNavBarTitle;

#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;

#pragma mark - Friends
+ (UIFont *) fontFriendsUsername;

#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;

#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;


#pragma mark - Chat
+ (UIFont *)fontTextMessageText;

@end
