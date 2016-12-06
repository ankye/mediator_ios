//
//  TLEmojiKBHelper.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLEmojiKBHelper : NSObject

+ (TLEmojiKBHelper *)sharedKBHelper;

- (void)emojiGroupDataByUserID:(NSString *)userID complete:(void (^)(NSMutableArray *))complete;

- (void)updateEmojiGroupData;


@end
