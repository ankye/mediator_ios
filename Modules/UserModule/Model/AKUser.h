//
//  AKUser.h
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseModel.h"
#import "AKUserProtocol.h"
#import "AKUserChatSettingProtocol.h"
#import "AKUserDetailProtocol.h"
#import "AKUserWeiboProtocol.h"
#import "AKUserHonorProtocol.h"


@interface AKUser : AKBaseModel<AKUserProtocol>

/// 用户ID
@property (nonatomic, strong) NSString *uid;

//靓号
@property (nonatomic, strong) NSString *usernum;

/// 用户名
@property (nonatomic, strong) NSString *username;

/// 昵称
@property (nonatomic, strong) NSString *nickname;

/// 头像URL
@property (nonatomic, strong) NSString *avatar;

/// 头像hd URL
@property (nonatomic, strong) NSString *avatarHD;

/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;

/// 备注名
@property (nonatomic, strong) NSString *remarkName;

//钱
@property (nonatomic, strong) NSNumber *money;
//二级货币
@property (nonatomic, strong) NSNumber *coin;

//最后一次修改昵称时间
@property (nonatomic, strong) NSNumber* lastNicknameModifyTime;
//最后一次登录时间 为空表示首次登录
@property (nonatomic, strong) NSNumber* lastLoginTime;
//最后一次充值时间 为空表示首次支付
@property (nonatomic, strong) NSNumber* lastPayTime;


#pragma mark - 列表用

@property (nonatomic, strong) NSString *pinyin;

@property (nonatomic, strong) NSString *pinyinInitial;


@property (nonatomic,strong) id<AKUserDetailProtocol,AKDataObjectProtocol> detail;
@property (nonatomic,strong) id<AKUserHonorProtocol,AKDataObjectProtocol> honor;
@property (nonatomic,strong) id<AKUserWeiboProtocol,AKDataObjectProtocol> weibo;
@property (nonatomic,strong) id<AKUserChatSettingProtocol,AKDataObjectProtocol> chatSetting;


-(void)fillData:(AKUser*)data;

@end
