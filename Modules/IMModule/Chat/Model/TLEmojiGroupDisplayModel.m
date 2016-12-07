//
//  TLEmojiGroupDisplayModel.m
//  TLChat
//
//  Created by 李伯坤 on 16/9/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLEmojiGroupDisplayModel.h"

@implementation TLEmojiGroupDisplayModel
- (id)initWithEmojiGroup:(TLEmojiGroup *)emojiGroup pageNumber:(NSInteger)pageNumber andCount:(NSInteger)count
{
    if (self = [super init]) {
        self.groupID = emojiGroup.groupID;
        self.groupName = emojiGroup.groupName;
        self.type = emojiGroup.type;
        
        self.rowNumber = emojiGroup.rowNumber;
        self.colNumber = emojiGroup.colNumber;
        self.pageItemCount = emojiGroup.pageItemCount;
        
        NSInteger start = pageNumber * count;
        if (emojiGroup.data.count > start) {
            NSInteger len = MIN(count, emojiGroup.count - start);
            self.data = [emojiGroup.data subarrayWithRange:NSMakeRange(pageNumber * count, len)];
        }
    }
    return self;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return index < self.data.count ? [self.data objectAtIndex:index] : nil;
}

- (void)addEmoji:(TLEmoji *)emoji
{
    NSMutableArray *emojis = [NSMutableArray arrayWithArray:self.data];
    [emojis addObject:emoji];
    self.data = emojis;
}
@end
