//
//  TLGroup.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/7.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLGroup.h"
#import "NSString+PinYin.h"
#import "TLUserHelper.h"

@implementation TLGroup

- (id)init
{
    if (self = [super init]) {
        [TLGroup mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"users" : @"AKUser" };
        }];
    }
    return self;
}

- (NSInteger)count
{
    return self.users.count;
}

- (void)addObject:(id)anObject
{
    [self.users addObject:anObject];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.users objectAtIndex:index];
}

- (AKUser *)memberByUserID:(NSString *)uid
{
    for (AKUser *user in self.users) {
        if ([user.uid isEqualToString:uid]) {
            return user;
        }
    }
    return nil;
}

- (NSString *)groupName
{
    if (_groupName == nil || _groupName.length == 0) {
        for (AKUser *user in self.users) {
            if (user.nickname.length > 0) {
                if (_groupName == nil || _groupName.length <= 0) {
                    _groupName = user.nickname;
                }
                else {
                    _groupName = [NSString stringWithFormat:@"%@,%@", _groupName, user.nickname];
                }
            }
        }
    }
    return _groupName;
}

- (NSString *)myNikeName
{
    if (_myNikeName.length == 0) {
        _myNikeName = [TLUserHelper sharedHelper].user.nickname;
    }
    return _myNikeName;
}

- (NSString *)pinyin
{
    if (_pinyin == nil) {
        _pinyin = self.groupName.pinyin;
    }
    return _pinyin;
}

- (NSString *)pinyinInitial
{
    if (_pinyinInitial == nil) {
        _pinyinInitial = self.groupName.pinyinInitial;
    }
    return _pinyinInitial;
}

- (NSString *)groupAvatarPath
{
    if (_groupAvatarPath == nil) {
        _groupAvatarPath = [self.groupID stringByAppendingString:@".png"];
    }
    return _groupAvatarPath;
}

@end
