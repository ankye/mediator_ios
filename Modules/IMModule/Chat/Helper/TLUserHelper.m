//
//  TLUserHelper.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLUserHelper.h"

static TLUserHelper *helper;

@implementation TLUserHelper

+ (TLUserHelper *) sharedHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[TLUserHelper alloc] init];
    });
    return helper;
}

- (NSString *)userID
{
    return self.user.userID;
}

- (id) init
{
    if (self = [super init]) {
        
       
    }
    return self;
}


-(void)setUserModel:(UserModel*)model
{
    self.user = [TLUserHelper userModelToTLUser:model];
 
}


+(TLUser*)userModelToTLUser:(UserModel*)model
{
    TLUser* user = [[TLUser alloc] init];
    user.userID = [model.uid stringValue];
    user.avatarURL = model.head;
    user.nikeName = model.nickname;
    user.username = [model.uid stringValue];
    user.detailInfo.sex = [model.sex integerValue] == 0 ? @"男":@"女";
    return user;
}

@end
