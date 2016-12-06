//
//  TLEmoji.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLChatMacros.h"

@interface TLEmoji : NSObject

@property (nonatomic, assign) TLEmojiType type;

@property (nonatomic, strong) NSString *groupID;

@property (nonatomic, strong) NSString *emojiID;

@property (nonatomic, strong) NSString *emojiName;

@property (nonatomic, strong) NSString *emojiPath;

@property (nonatomic, strong) NSString *emojiURL;

@property (nonatomic, assign) CGFloat size;

@end
