//
//  TLUser+ChatModel.m
//  TLChat
//
//  Created by 李伯坤 on 16/5/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "AKUser+ChatModel.h"

@implementation AKUser (ChatModel)

- (NSString *)chat_userID
{
    return self.uid;
}

- (NSString *)chat_username
{
    return self.nickname;
}

- (NSString *)chat_avatarURL
{
    return self.avatar;
}

- (NSString *)chat_avatarPath
{
    return self.avatarPath;
}

- (NSInteger)chat_userType
{
    return TLChatUserTypeUser;
}

@end
