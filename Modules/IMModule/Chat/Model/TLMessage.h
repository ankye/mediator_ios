//
//  TLMessage.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLMessageProtocol.h"
#import "TLMessageFrame.h"
#import "TLChatUserProtocol.h"

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, TLMessageType) {
    TLMessageTypeUnknown,
    TLMessageTypeText,          // 文字
    TLMessageTypeImage,         // 图片
    TLMessageTypeExpression,    // 表情
    TLMessageTypeVoice,         // 语音
    TLMessageTypeVideo,         // 视频
    TLMessageTypeURL,           // 链接
    TLMessageTypePosition,      // 位置
    TLMessageTypeBusinessCard,  // 名片
    TLMessageTypeSystem,        // 系统
    TLMessageTypeOther,
};


/**
 *  消息所有者类型
 */
typedef NS_ENUM(NSInteger, TLPartnerType){
    TLPartnerTypeUser,          // 用户
    TLPartnerTypeGroup,         // 群聊
};

/**
 *  消息拥有者
 */
typedef NS_ENUM(NSInteger, TLMessageOwnerType){
    TLMessageOwnerTypeUnknown,  // 未知的消息拥有者
    TLMessageOwnerTypeSystem,   // 系统消息
    TLMessageOwnerTypeSelf,     // 自己发送的消息
    TLMessageOwnerTypeFriend,   // 接收到的他人消息
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSInteger, TLMessageSendState){
    TLMessageSendSuccess,       // 消息发送成功
    TLMessageSendFail,          // 消息发送失败
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSInteger, TLMessageReadState) {
    TLMessageUnRead,            // 消息未读
    TLMessageReaded,            // 消息已读
};


@interface TLMessage : NSObject<TLMessageProtocol>
{
    TLMessageFrame *kMessageFrame;
}

@property (nonatomic, strong) NSString *messageID;                  // 消息ID
@property (nonatomic, strong) NSString *userID;                     // 发送者ID
@property (nonatomic, strong) NSString *friendID;                   // 接收者ID
@property (nonatomic, strong) NSString *groupID;                    // 讨论组ID（无则为nil）

@property (nonatomic, strong) NSDate *date;                         // 发送时间

@property (nonatomic, strong) id<TLChatUserProtocol> fromUser;      // 发送者

@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showName;

@property (nonatomic, assign) TLPartnerType partnerType;            // 对方类型
@property (nonatomic, assign) TLMessageType messageType;            // 消息类型
@property (nonatomic, assign) TLMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) TLMessageReadState readState;         // 读取状态
@property (nonatomic, assign) TLMessageSendState sendState;         // 发送状态

@property (nonatomic, strong) NSMutableDictionary *content;

@property (nonatomic, strong, readonly) TLMessageFrame *messageFrame;         // 消息frame

+ (TLMessage *)createMessageByType:(TLMessageType)type;

- (void)resetMessageFrame;


@end
