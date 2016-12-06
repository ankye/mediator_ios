//
//  TLChatMacros.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef TLChatMacros_h
#define TLChatMacros_h


#pragma mark - # Debug
#define     DEBUG_LOCAL_SERVER      // 使用本地测试服务器
//#define     DEBUG_MEMERY            // 内存测试
//#define     DEBUG_JSPATCH           // JSPatch本地测试


#pragma mark - # URL
#define     IEXPRESSION_HOST_URL        @"http://123.57.155.230/ibiaoqing/admin/"



#define     HEIGHT_CHATBAR_TEXTVIEW         36.0f
#define     HEIGHT_MAX_CHATBAR_TEXTVIEW     111.5f
#define     HEIGHT_CHAT_KEYBOARD            215.0f

#define     MAX_MESSAGE_WIDTH               SCREEN_WIDTH * 0.58
#define     MAX_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.45
#define     MIN_MESSAGE_IMAGE_WIDTH         SCREEN_WIDTH * 0.25
#define     MAX_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.35
#define     MIN_MESSAGE_EXPRESSION_WIDTH    SCREEN_WIDTH * 0.2


#pragma mark - # Methods
#define     TLURL(urlString)    [NSURL URLWithString:urlString]
#define     TLNoNilString(str)  (str.length > 0 ? str : @"")
#define     TLWeakSelf(type)    __weak typeof(type) weak##type = type;
#define     TLStrongSelf(type)  __strong typeof(type) strong##type = type;
#define     TLTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])
#define     TLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

typedef NS_ENUM(NSInteger, TLEmojiType) {
    TLEmojiTypeEmoji,
    TLEmojiTypeFavorite,
    TLEmojiTypeFace,
    TLEmojiTypeImage,
    TLEmojiTypeImageWithTitle,
    TLEmojiTypeOther,
};

typedef NS_ENUM(NSInteger, TLChatBarStatus) {
    TLChatBarStatusInit,
    TLChatBarStatusVoice,
    TLChatBarStatusEmoji,
    TLChatBarStatusMore,
    TLChatBarStatusKeyboard,
};


#endif /* TLChatMacros_h */
