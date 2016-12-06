//
//  TLEmoji.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "TLEmoji.h"
#import "NSFileManager+Paths.h"
#import "NSFileManager+ExpressionGroup.h"

@implementation TLEmoji


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"emojiID" : @"pId",
             @"emojiURL" : @"Url",
             @"emojiName" : @"credentialName",
             @"emojiPath" : @"imageFile",
             @"size" : @"size",
             };
}



- (NSString *)emojiPath
{
    if (_emojiPath == nil) {
        NSString *groupPath = [NSFileManager pathExpressionForGroupID:self.groupID];
        _emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, self.emojiID];
    }
    return _emojiPath;
}

@end
