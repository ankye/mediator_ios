//
//  AKUser.m
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUser.h"

@implementation AKUser

-(void)fillData:(id)data
{
    if([data conformsToProtocol:@protocol(AKUserProtocol)]){
       [self fillUserData:data];
    }
}


-(void)fillUserData:(id<AKUserProtocol>)user
{
    self.uid = user.uid;
    self.usernum = user.usernum;
    self.username = user.username;
    self.nickname = user.nickname;
    self.avatar = user.avatar;
    self.avatarHD = user.avatarHD;
    self.avatarPath = user.avatarPath;
    self.remarkName = user.remarkName;
    self.money = user.money;
    self.coin = user.coin;
    self.lastNicknameModifyTime = user.lastNicknameModifyTime;
    self.lastLoginTime = user.lastLoginTime;
    self.lastPayTime = user.lastPayTime;
    self.pinyin = user.pinyin;
    self.pinyinInitial = user.pinyinInitial;
    
}

@end
