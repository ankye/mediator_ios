//
//  AKUser.h
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "TLBaseDataModel.h"
#import "AKUserProtocol.h"
#import "AKUserChatSettingProtocol.h"
#import "AKUserDetailProtocol.h"
#import "AKUserWeiboProtocol.h"
#import "AKUserHonorProtocol.h"
#import "AKUserSettingProtocol.h"

@interface AKUser : TLBaseDataModel

@property (nonatomic,strong) NSString* uid;

@property (nonatomic,strong) id<AKUserProtocol> baseinfo;
@property (nonatomic,strong) id<AKUserDetailProtocol> detail;
@property (nonatomic,strong) id<AKUserHonorProtocol> honor;
@property (nonatomic,strong) id<AKUserWeiboProtocol> weibo;
@property (nonatomic,strong) id<AKUserSettingProtocol> userSetting;
@property (nonatomic,strong) id<AKUserChatSettingProtocol> chatSetting;

@end
