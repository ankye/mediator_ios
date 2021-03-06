//
//  TLExpressionHelper.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "TLExpressionHelper.h"
#import "NSFileManager+TLChat.h"
#import "AKDBManager+TLChat.h"
#import "TLEmojiKBHelper.h"
#import "TLChatMacros.h"
#import "TLHostHelper.h"
#import "TLSettingGroup.h"
#import "TLUserHelper.h"

@interface TLExpressionHelper ()


@end

@implementation TLExpressionHelper
@synthesize defaultFaceGroup = _defaultFaceGroup;
@synthesize defaultSystemEmojiGroup = _defaultSystemEmojiGroup;
@synthesize userEmojiGroups = _userEmojiGroups;

+ (TLExpressionHelper *)sharedHelper
{
    static TLExpressionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TLExpressionHelper alloc] init];
    });
    return helper;
}

- (NSArray *)userEmojiGroups:(NSString*)uid
{
    return [AK_DB_MANAGER expressionGroupsByUid:uid];
}

- (BOOL)addExpressionGroup:(TLEmojiGroup *)emojiGroup
{
    BOOL ok = [AK_DB_MANAGER addExpressionGroup:emojiGroup forUid:[TLUserHelper sharedHelper].userID];
    if (ok) {       // 通知表情键盘
        [[TLEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
    }
    return ok;
}

- (BOOL)deleteExpressionGroupByID:(NSString *)groupID
{
    BOOL ok = [AK_DB_MANAGER deleteExpressionGroupByID:groupID forUid:[TLUserHelper sharedHelper].userID];
    if (ok) {       // 通知表情键盘
        [[TLEmojiKBHelper sharedKBHelper] updateEmojiGroupData];
    }
    return ok;
}

- (BOOL)didExpressionGroupAlwaysInUsed:(NSString *)groupID
{
    NSInteger count = [AK_DB_MANAGER countOfUserWhoHasExpressionGroup:groupID];
    return count > 0;
}

- (TLEmojiGroup *)emojiGroupByID:(NSString *)groupID;
{
    for (TLEmojiGroup *group in self.userEmojiGroups) {
        if ([group.groupID isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}

- (void)downloadExpressionsWithGroupInfo:(TLEmojiGroup *)group
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(TLEmojiGroup *))success
                                 failure:(void (^)(TLEmojiGroup *, NSString *))failure
{
    group.type = TLEmojiTypeImageWithTitle;
    dispatch_queue_t downloadQueue = dispatch_queue_create([group.groupID UTF8String], nil);
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    for (int i = 0; i <= group.data.count; i++) {
        dispatch_group_async(downloadGroup, downloadQueue, ^{
            NSString *groupPath = [NSFileManager pathExpressionForGroupID:group.groupID];
            NSString *emojiPath;
            NSData *data = nil;
            if (i == group.data.count) {
                emojiPath = [NSString stringWithFormat:@"%@icon_%@", groupPath, group.groupID];
                data = [NSData dataWithContentsOfURL:TLURL(group.groupIconURL)];
            }
            else {
                TLEmoji *emoji = group.data[i];
                NSString *urlString = [TLHostHelper expressionDownloadURLWithEid:emoji.emojiID];
                data = [NSData dataWithContentsOfURL:TLURL(urlString)];
                if (data == nil) {
                    urlString = [TLHostHelper expressionURLWithEid:emoji.emojiID];
                    data = [NSData dataWithContentsOfURL:TLURL(urlString)];
                }
                emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, emoji.emojiID];
            }
            
            [data writeToFile:emojiPath atomically:YES];
        });
    }
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        success(group);
    });
}


- (NSMutableArray *)myExpressionListData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *myEmojiGroups = [NSMutableArray arrayWithArray:[AK_DB_MANAGER expressionGroupsByUid:[TLUserHelper sharedHelper].userID]];
    if (myEmojiGroups.count > 0) {
        TLSettingGroup *group1 = TLCreateSettingGroup(@"聊天面板中的表情", nil, myEmojiGroups);
        [data addObject:group1];
    }
    
    TLSettingItem *userEmojis = TLCreateSettingItem(@"添加的表情");
    TLSettingItem *buyedEmojis = TLCreateSettingItem(@"购买的表情");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[userEmojis, buyedEmojis]));
    [data addObject:group2];
    
    return data;
}

- (TLEmojiGroup *)defaultFaceGroup
{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [[TLEmojiGroup alloc] init];
        _defaultFaceGroup.type = TLEmojiTypeFace;
        _defaultFaceGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultFaceGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
        for (TLEmoji *emoji in _defaultFaceGroup.data) {
            emoji.type = TLEmojiTypeFace;
        }
    }
    return _defaultFaceGroup;
}

- (TLEmojiGroup *)defaultSystemEmojiGroup
{
    if (_defaultSystemEmojiGroup == nil) {
        _defaultSystemEmojiGroup = [[TLEmojiGroup alloc] init];
        _defaultSystemEmojiGroup.type = TLEmojiTypeEmoji;
        _defaultSystemEmojiGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultSystemEmojiGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
    }
    return _defaultSystemEmojiGroup;
}

@end
